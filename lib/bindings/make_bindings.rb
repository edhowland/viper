# make_bindings.rb - returns hash of key bindings to procs

def make_bindings
  result = {}
('a'..'z').inject(result) {|i,j| s,p=inserter(j); i[s] = p; i}
  ('A'..'Z').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}
  ('0'..'9').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}

  # Control characters
  result[:ctrl_q] = ->(b) {:quit }
  result[:ctrl_a] = ->(b) { b.front_of_line; say b.at }
  result[:ctrl_e] = ->(b) { b.back_of_line; say b.at }
  result[:ctrl_t] = ->(b) { b.beg; say "top of buffer" }
  result[:ctrl_b] = ->(b) { b.fin; say "bottom of buffer" }
  result[:ctrl_y] = ->(b) { say "buffer is: #{b.name}" }
  result[:ctrl_o] = ->(b) { b.back_of_line; b.ins "\n"; say b.at }
  result[:ctrl_p] = ->(b) { say b.look_ahead.join("\n") }
  result[:ctrl_f] = ->(b) { say BELL }
  result[:ctrl_r] = ->(b) { say BELL }

  # command controls
  result[:ctrl_d] = ->(b) { :debug }
  result[:ctrl_c] = ->(b) { say BELL}
  result[:ctrl_s] = ->(b) {:save }

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
  result[:ctrl_h] = ->(b) {:help }
  result[:ctrl_j] = ->(b) { say b.at }
  result[:ctrl_k] = ->(b) { say b.col }
  result[:ctrl_l] = ->(b) { say b.line }
  result[:right] = ->(b) { b.fwd; say b.at}
  result[:left] = ->(b) { b.back; say b.at}
  result[:up] = ->(b) { b.up; say b.line }
  result[:down] = ->(b) { b.down; say b.line }
  result[:backspace] =->(b) { ch= b.del; say "delete #{ch}" }

  # Function keys
  result[:fn_1] = ->(b) { :snippet_record }
  result[:fn_2] = ->(b) { :snippet_playback }
  result[:fn_3] = ->(b) { say BELL }
  result[:fn_4] = ->(b) { say BELL }
  result
end
