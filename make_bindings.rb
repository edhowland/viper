# bindings.rb - returns hash of key bindings to procs
BELL = "\a"

def make_bindings
  result = {}
('a'..'z').inject(result) {|i,j| s,p=inserter(j); i[s] = p; i}
  ('A'..'Z').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}
  ('0'..'9').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}

  # Control chars
  result[:ctrl_c] = ->(b) { say BELL}
  result[:ctrl_s] = ->(b) { say "save not implemented" }

  # punctuation
  result[:colon] = insert_sym ':'
  result[:semicolon] = insert_sym ';'
  result[:period] = insert_sym '.'
  result[:comma] = insert_sym ','
  result[:space] = inserter(' ')[1]

  [
  [:apostrophe, "'"], [:quote, '"'], 
    [:asterisk, '*'], [:accent, '``'], [:at, '@'],
    [:tilde, '~'], [:exclamation, '!'], [:number, '#'],
    [:dollar, '$'], [:percent, '%'], [:caret, '^'],
    [:ampersand, '&'],
    [:lparen, '('], [:rparen, ')'], [:hyphen, '-'],
    [:underline, '_'], [:plus, '+'], [:equals, '='],
    [:backslash, '\\'], [:pipe, '|'],
    [:lbracket, '['], [:rbracket, ']'],
    [:lbrace, '{'], [:rbrace, '}'],
    [:less, '<'], [:greater, '>'], [:question, '?'], [:slash, '/']
  ].inject(result) {|i, j| i[j[0]] = insert_sym(j[1]); i }
  result[:return] = ->(b) { b.ins "\n"; say 'return' }
  result[:tab] = ->(b) { b.ins '  '; say 'tab' }
  result[:ctrl_l] = ->(b) { say b.line }
  result[:ctrl_j] = ->(b) { say b.at }
  result[:ctrl_k] = ->(b) { say b.col }
  result[:right] = ->(b) { b.fwd; say b.at}
  result[:left] = ->(b) { b.back; say b.at}
  result[:up] = ->(b) { b.up; say b.line }
  result[:down] = ->(b) { b.down; say b.line }
  result[:backspace] =->(b) { ch= b.del; say "delete #{ch}" }
  result
end
