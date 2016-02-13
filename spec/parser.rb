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


# recursion fns

def star &blk
  star(&blk) if yield
  true
end

def plus &blk
  yield && star(&blk)
end

# non terminals

def nonterm_expr(buffer, &blk)
  match_word(buffer) && star { match_whitespace(buffer) && match_word(buffer) }
end

# root 

def nonterm_command(buffer, &blk)
  nonterm_expr(buffer) && star { match_semicolon(buffer) && nonterm_expr(buffer) }
end
