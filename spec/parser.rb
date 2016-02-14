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
  match_thing buffer, /^(\w+)/, &blk
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
  match_thing(buffer, /^(;)/, &blk)
end

def match_nonwhitespace buffer, &blk
  match_thing(buffer, /^([^\s';]+)/, &blk)
end

def match_string buffer, &blk
  result = match_thing(buffer, /^'([^']+)'/, &blk)
  buffer.fwd(2) if result # consume the quotes
  result
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

# non terminals

def nonterm_comment buffer, &blk
  match_octothorpe(buffer) && star { match_anything(buffer) } && match_end(buffer)
end


def nonterm_arg buffer, &blk
  match_nonwhitespace(buffer) || match_string(buffer)
end

def nonterm_expr(buffer, &blk)
  match_word(buffer) && star { match_whitespace(buffer) && nonterm_arg(buffer) }
end

# root 

def nonterm_command(buffer, &blk)
  nonterm_expr(buffer) && star { match_semicolon(buffer) && nonterm_expr(buffer) } && question { nonterm_comment(buffer) }
end

# util fns

def syntax_ok? buffer
  result = nonterm_command(buffer)
  raise CommandSyntaxError.new "at position #{buffer.position}" unless result
  raise CommandSyntaxError.new "Unexpected end of input" unless buffer.eob?
  result && buffer.eob?
end

###### TESTING
def n string
  Buffer.new string
end
