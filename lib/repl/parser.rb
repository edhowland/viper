# parser.rb - methods  for parsing command strings with multiple commands

def match_thing(buffer, regex, &_blk)
  result = buffer.match  regex
  yield result if result && block_given?
  buffer.fwd(result.length) if result
  !result.nil?
end
# matches a word
def match_word(buffer, &blk)
  match_thing buffer, /^([\w_!\+\-]+)/, &blk
end

def match_whitespace(buffer, &blk)
  match_thing buffer, /^( +)/, &blk
end

# def match_digit buffer, &blk
#  match_thing buffer, /^(\d)/, &blk
# end

def match_end(buffer)
  buffer.eob?
end

def match_newline buffer, &blk
  match_thing buffer, /^(\s*\n\s*)/, &blk
end

def match_semicolon(buffer, &blk)
  match_thing(buffer, /^(\s*;\s*)/, &blk)
end

def match_newline_or_semicolon(buffer, &blk)
  match_newline(buffer, &blk) || match_semicolon(buffer, &blk)
end

def match_nonwhitespace(buffer, &blk)
  match_thing(buffer, /^([^\s"';]+)/, &blk)
end

# matches '#' - an octothorpe
def match_octothorpe(buffer, &blk)
  match_thing(buffer, /^(#)/, &blk)
end

def match_anything(buffer, &blk)
  match_thing(buffer, /^(.+)/, &blk)
end

# recursion fns
# matches 0 or one of something
def question(&_blk)
  !yield || !yield
end

# matches 0 or more of somethings
def star(&blk)
  star(&blk) if yield
  true
end

# matches one or more of things
def plus(&blk)
  yield && star(&blk)
end

def error(exception = nil, &_blk)
  result = !yield

  fail exception if !result && !exception.nil?
  result
end

# non terminals

def nonterm_quote(buffer, &_blk)
  string = ''
  result = match_thing(buffer, /^(')/) && match_thing(buffer, /^([^']*)/) { |w| string = w } && (match_thing(buffer, /^(')/) || error(CommandSyntaxError.new('Unterminated string')) { match_end(buffer) })
  yield string if block_given? && result
  result
end

def nonterm_dblquote(buffer, &_blk)
  string = ''
  result = match_thing(buffer, /^(")/) && match_thing(buffer, /^([^"]*)/) { |w| string = w } && (match_thing(buffer, /^(")/) || error(CommandSyntaxError.new('Unterminated string')) { match_end(buffer) })
  # match_thing(buffer, /^(")/)
  yield string if block_given? && result
  result
end

def nonterm_string(buffer, &blk)
  nonterm_quote(buffer, &blk) || nonterm_dblquote(buffer, &blk)
end

def nonterm_comment(buffer, &_blk)
  match_octothorpe(buffer) && star { match_anything(buffer) } && match_end(buffer)
end

def nonterm_arg(buffer, &_blk)
  arg = ''
  result = match_nonwhitespace(buffer) { |w| arg = w } || nonterm_string(buffer) { |w| arg = w }
  yield arg if block_given? && result
  result
end
# match an expression - a word (cmd) some optional args and some whitespace
def nonterm_expr(buffer, _sexp = [], &_blk)
  args = []
  sym = :nop
  result = match_word(buffer) { |w| sym = w.to_sym } && star { match_whitespace(buffer) && nonterm_arg(buffer) { |a| args << a } }
  yield [sym, args] if block_given? && result
  result
end

# root

def nonterm_command(buffer, &_blk)
  sexps = []
  result = match_end(buffer) ||
           nonterm_comment(buffer) ||
           nonterm_expr(buffer) { |sexp| sexps << sexp } && star { match_newline_or_semicolon(buffer) && nonterm_expr(buffer) { |sexp| sexps << sexp } } && question { nonterm_comment(buffer) }
  yield sexps if block_given? && result
  result
end

# util fns

def syntax_ok?(buffer)
  st = buffer.to_s.strip
  buffer = Buffer.new(st)
  result = nonterm_command(buffer)
  fail CommandSyntaxError.new "Syntax error at position #{buffer.position}" unless result
  fail CommandSyntaxError.new 'Unexpected end of input' unless buffer.eob?
  result && buffer.eob?
end

def parse!(string)
  buffer = Buffer.new string.strip
  sexps = []
  result = nonterm_command(buffer) { |s| sexps = s }
  fail CommandSyntaxError.new "Syntax error at position #{buffer.position}" unless result
  fail CommandSyntaxError.new 'Unexpected end of input' unless buffer.eob?

  sexps
end
