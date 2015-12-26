#!/usr/bin/env ruby
# loop.rb - event loop for editor

require 'io/console'
require_relative 'key_mappings'
require_relative 'key_press'
require_relative 'map_key'
require_relative 'lib/edit_buffer'
require_relative 'inserter'
require_relative 'bindings'

loop do
print 'E>> '
  x = key_press
  puts 'x is'
  p x
  puts 'map x is'
  p map_key(x)
  break if x == "\003" or x == 'q'
end
