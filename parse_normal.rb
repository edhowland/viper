# vim.rb - parser for Vim parser

require_relative '../parser-combinator/test/spec_helpers'
require_relative 'xfkey'

# xform input to cannonical name, if not a letter or number
def xform_ch(ch)
  xk = Xfkey.new
  result = xk.key_to_name ch
  if result == 'unknown'
    ch
  else
    result
  end
end


def vim
  Grammar.build do
    # the 'G' when proceeded with a number, like 12G : means goto line 12
    rule(:single) { str('G') | str('e') | str('E') | str('b') | str('B') | str('_') |
      str('h') | str('j') | str('k') | str('l') | str('$') | str('"') | str("'") | str('#') | str('/') | str('?') | str('^') | str('%') |  str('!') | str('*') | str('x') | str('f') | str('F') | str('w') | str('W')| str('i') | str('I') | str('a') | str('A') | str('o') | str('O') | str('p') | str('P') | str('L') | str('u')}
    rule(:mark) { str('m') >> anyLetter }
    rule(:rec_macro) { str('q') >> anyLetter }
    rule(:play_macro) { str('@') >> (anyLetter | str('@')) }
    
    rule(:text_objects) { str('W') | str('w') | str('G') | str('$') | str('0') | str('^') }
    rule(:delete) { (str('dd') | (str('d') >> rule(:text_objects))) }
    rule(:change) { str('cc') | (str('c') >> rule(:text_objects)) }
    rule(:yank) { str('yy') | (str('y') >> rule(:text_objects)) }

  rule(:goto) { str('gg') | str('g$') | str('g_') }

    rule(:double) { str('ZZ') | rule(:delete) |rule(:change) | rule(:yank) | rule(:mark) | rule(:rec_macro) | rule(:play_macro) | rule(:goto) }
    rule(:triple) { str('diw') | str('ciw') | str('caw') | str('daw') }
    rule(:command) { rule(:triple) | rule(:double) | rule(:single) }

    start(:command)
  end
end


def get_cmd ch=''
  p = vim
  ch = (ch.empty? ? $stdin.getch : ch)
  r = p.run(ch)
  if r.fail?
    ch = ch + $stdin.getch
    r = p.run(ch)
    if r.fail?
      ch = ch + $stdin.getch
      r = p.run(ch)
    end
  end
  ch
end

def digits
  Grammar.build do
    rule(:digits) { many1 { anyNumber } }

  start(:digits)
  end
end


def get_digits ch=''
  p = digits
  ch = ch + $stdin.getch
  r = p.run(ch)
  if r.ok? and r.remaining.empty?
  m,r = get_digits(ch)
  else
    m = r.matched
    r = r.remaining
  end
  [m, r]
end

def floor(n)
  n.zero? ? 1 : n
end

# Main parser for normal mode
def parse_normal
  m,r = get_digits
  c = get_cmd(r)
  [floor(m.to_i), xform_ch(c).to_sym]
end