#!/usr/bin/env ruby
# parser.rb - methods  for parsing command strings with multiple commands

# restore position of buffer if expression is false
def _r buffer, &blk
  saved = buffer.position
  result = yield
  buffer.goto_position(saved) unless result
  result 
end

def match_thing buffer, regex, &blk
  result = buffer.match  regex
  yield result if result && block_given?
  buffer.fwd(result.length) if result
  !result.nil?
end

def match_word buffer, &blk
  match_thing buffer, /^([\w_!]+)/, &blk
end

def match_whitespace buffer, &blk
  match_thing buffer, /^(\s+)/, &blk
end

def match_digit buffer, &blk
  match_thing buffer, /^(\d)/, &blk
end

def match_end buffer
  buffer.eob?
end

def match_semicolon buffer, &blk
  match_thing(buffer, /^(\s*;\s*)/, &blk)
end

def match_nonwhitespace buffer, &blk
  match_thing(buffer, /^([^\s"';]+)/, &blk)
end


def match_octothorpe buffer, &blk
  match_thing(buffer, /^(#)/, &blk)
end

def match_anything buffer, &blk
  match_thing(buffer, /^(.+)/, &blk)
end

# recursion fns

def question &blk
  !yield || !yield
end


def star &blk
  star(&blk) if yield
  true
end

def plus &blk
  yield && star(&blk)
end

def error exception=nil, &blk
  result = ! yield

  raise exception if !result && !exception.nil?
  result
end

# non terminals

# FIXME - replace nonterm_quote with nt_quote
def nt_quote(buffer, &blk)
  match_thing(buffer, /^(')/) && match_thing(buffer, /^([^']*)/) && (match_thing(buffer, /^(')/) || error(CommandSyntaxError.new('Unterminated string')) { match_end(buffer) })
end


def nonterm_quote buffer, &blk
  string = ''
  result = match_thing(buffer, /^(')/) && match_thing(buffer, /^([^']*)/) {|w| string = w } &&(match_thing(buffer, /^(')/) || error(CommandSyntaxError.new('Unterminated string')) { match_end(buffer) }) 
  yield string if block_given? && result
  result
end

def nonterm_dblquote buffer, &blk
  string = ''
  result =match_thing(buffer, /^(")/) && match_thing(buffer, /^([^"]*)/) {|w| string = w } &&(match_thing(buffer, /^(")/)  || error(CommandSyntaxError.new('Unterminated string')) { match_end(buffer) }) 
#match_thing(buffer, /^(")/) 
  yield string if block_given? && result
  result
end

def nonterm_string(buffer, &blk)
  nonterm_quote(buffer, &blk) || nonterm_dblquote(buffer, &blk)
end


def nonterm_comment buffer, &blk
  match_octothorpe(buffer) && star { match_anything(buffer) } && match_end(buffer)
end


def nonterm_arg buffer, &blk
  arg = ''
  result = match_nonwhitespace(buffer) {|w| arg = w } || nonterm_string(buffer) {|w| arg = w }
  yield arg if block_given? && result
  result
end

def nonterm_expr(buffer, sexp=[], &blk)
  args = []
  sym = :nop
  result = match_word(buffer) {|w| sym = w.to_sym } && star { match_whitespace(buffer) && nonterm_arg(buffer) {|a| args << a } }
  yield [ sym, args ] if block_given? && result
  result
end

# root 

def nonterm_command(buffer, &blk)
  sexps = []
  result = match_end(buffer) ||
  nonterm_comment(buffer) ||
  nonterm_expr(buffer) {|sexp| sexps << sexp } && star { match_semicolon(buffer) && nonterm_expr(buffer) {|sexp| sexps << sexp } } && question { nonterm_comment(buffer) }
  yield sexps if block_given? && result
  result
end

# util fns

def syntax_ok? buffer
  st = buffer.to_s.strip
  buffer = Buffer.new(st)
  result = nonterm_command(buffer)
  raise CommandSyntaxError.new "Syntax error at position #{buffer.position}" unless result
  raise CommandSyntaxError.new "Unexpected end of input" unless buffer.eob?
  result && buffer.eob?
end

def parse! string
  buffer = Buffer.new string.strip
  sexps = []
  result = nonterm_command(buffer) {|s| sexps = s }
  raise CommandSyntaxError.new "Syntax error at position #{buffer.position}" unless result
  raise CommandSyntaxError.new "Unexpected end of input" unless buffer.eob?

  sexps
end

# REMOVEME
###### TESTING
def n string
  Buffer.new string
end


def read_command
  rl = Viper::Readline.new
  loop do
    say 'command'
  cmd = rl.readline
    buf = Buffer.new cmd
  break if cmd == 'q'
    say 'syntax ok' if syntax_ok?(buf)
  end
end
