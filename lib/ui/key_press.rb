# key_press.rb - method key_press
require 'io/console'

# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = y = z = p = q = r = ''
  x = $stdin.getch
  if x == "\e"
    y = $stdin.getch
    if y == "[" or y == "O" or y == 'Z'
      z = $stdin.getch
    if z == '1' or z == '2' or z == '3'
      p =$stdin.getch
    unless p == '~'
      q = $stdin.getch
      r = $stdin.getch unless q == '~'
    end
    elsif z == '5' or z == '6'   # for shift+PgUp, Shift+PgDn
      p = $stdin.getch
    end
    end
  end
  x + y + z + p + q +r
end
