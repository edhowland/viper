#!/usr/bin/env ruby
# loop.rb - event loop for editor
require 'io/console'

loop do
x=''
y=''
  z=''
print 'E>> '
x = $stdin.getch
if x == "\e"
  y = $stdin.getch
  if y == '['
    z = $stdin.getch
  end
end
puts 'x is '
p x, y, z
  break if x == "\003" or x == 'q'
end
