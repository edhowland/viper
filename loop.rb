#!/usr/bin/env ruby
# loop.rb - event loop for editor
require 'io/console'

# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = y = z = ''
  x = $stdin.getch
  if x == "\e"
    y = $stdin.getch
    if y == "["
      z = $stdin.getch
    end
  end
  x + y + z
end

loop do
print 'E>> '
  x = key_press
  puts 'x is'
  p x
  break if x == "\003" or x == 'q'
end
