# key_press.rb - method key_press
require 'io/console'


# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = y = z = ''
  x = $stdin.getch
  if x == "\e"
    y = $stdin.getch
    if y == "[" or y == "O"
      z = $stdin.getch
    end
  end
  x + y + z
end
