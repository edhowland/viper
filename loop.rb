#!/usr/bin/env ruby
# loop.rb - event loop for editor
require 'io/console'
require_relative 'key_mappings'
require_relative 'key_press'
def map_key(press, mappings=key_mappings)
  result = mappings[press]
  result || press
end


loop do
print 'E>> '
  x = key_press
  puts 'x is'
  p x
  puts 'map x is'
  p map_key(x)
  break if x == "\003" or x == 'q'
end
