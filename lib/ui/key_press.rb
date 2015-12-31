# key_press.rb - method key_press
require 'io/console'

# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = y = z = p = q = r = ''
  x = $stdin.getch
  if x == "\e"
    y = $stdin.getch
    if y == "[" or y == "O"
      z = $stdin.getch
    if z == '1'
      p = key_press; q = key_press; r = key_press
    elsif z == '5' or z == '6'   # for shift+PgUp, Shift+PgDn
      p = key_press
    end
    end
  end
  x + y + z + p + q +r
end
