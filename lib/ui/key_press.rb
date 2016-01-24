# key_press.rb - method key_press
require 'io/console'

def handle_lbrkt
z = p = q = r = ''
      z = $stdin.getch
    if z == '1' or z == '2' or z == '3'
      p =$stdin.getch
    unless p == '~'
      q = $stdin.getch
      r = $stdin.getch unless q == '~'
    end
    elsif z == '5' or z == '6'   
      p = $stdin.getch
    end


  z + p + q + r
end


def handle_esc
    y = $stdin.getch
    y += handle_lbrkt if y == "[" or y == "O" or y == 'Z'
  y
end

# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = y = z = p = q = r = ''
  x = $stdin.getch
  x += handle_esc if x == "\e"

  x
end
