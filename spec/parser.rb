#!/usr/bin/env ruby
# parser.rb - methods  for parsing command strings with multiple commands

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
  match_thing buffer, /^(\d)/
end

# recursion fns

def star &blk
  star(&blk) if yield
  true
end

def plus &blk
  yield && star(&blk)
end
