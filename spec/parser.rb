#!/usr/bin/env ruby
# parser.rb - methods  for parsing command strings with multiple commands

def match_thing buffer, regex, &blk
  result = buffer.match  regex
  yield result if result && block_given?
  buffer.fwd(result.length) if result
  !result.nil?
end
