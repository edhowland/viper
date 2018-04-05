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
    rule(:single) { str('h') | str('j') | str('k') | str('l') | str('$') | str('"') | str("'") | str('#') | str('/') | str('?') | str('^') | str('%') | str('@') | str('!') | str('*') }
    rule(:double) { str('dd') | str('dw') | str('cc') | str('cw') | str('ma') | str('mm') }
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