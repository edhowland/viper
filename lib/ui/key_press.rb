# key_press.rb - method key_press
require 'io/console'

def handle_numeric
  p = $stdin.getch
  return p if p == '~'
  q = $stdin.getch
  return p + q if q == '~'
  r = $stdin.getch

  p + q + r
end

def handle_lbrkt
  # p = q = r = ''
  z = $stdin.getch
  z += handle_numeric if %w(1 2 3 5 6).member? z

  z
end

def handle_esc
  y = $stdin.getch
  y += handle_lbrkt if y == "[" or y == "O" or y == 'Z'
  y
end

# read console input one keypress. If Escape sequence, keep consuming until done
def key_press
  x = $stdin.getch
  x += handle_esc if x == "\e"

  x
end
