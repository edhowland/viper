# make_bindings.rb - returns hash of key bindings to procs

def make_bindings
  result = {}
('a'..'z').inject(result) {|i,j| s,p=inserter(j); i[s] = p; i}
  ('A'..'Z').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}
  ('0'..'9').inject(result) {|i, j| s,p = inserter(j); i[s] = p; i}

  # Control characters
  result[:ctrl_q] = ->(b) {:quit }
  result[:shift_home] = ->(b) { b.front_of_line; say b.at }
  result[:shift_end] = ->(b) { b.back_of_line; say b.at }
  result[:shift_pgup] = ->(b) { b.beg; say "top of buffer" }
  result[:shift_pgdn] = ->(b) { b.fin; say "bottom of buffer" }
  result[:ctrl_y] = ->(b) { say "buffer is: #{b.name}: #{b.position}" }
  result[:ctrl_o] = ->(b) { b.back_of_line; b.ins "\n"; say b.at }
  result[:ctrl_p] = ->(b) { say b.look_ahead.join("\n") }
  result[:ctrl_f] = ->(b) { :srch_fwd }
  result[:ctrl_r] = ->(b) { :srch_back }
  result[:ctrl_z] = ->(b) { b.undo; say 'Undone' }
  result[:ctrl_u] = ->(b) { b.redo; say 'Redone' }

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
  result[:backspace] =->(b) { 
    if b.mark_set?
      $clipboard = b.cut; say 'selection deleted'
    else
  ch= b.del; say "delete #{ch}" 
    end
  }

  # Function keys
  result[:fn_1] = ->(b) { :snippet_record }
  result[:fn_2] = ->(b) { :snippet_playback }
  result[:fn_3] = ->(b) { say BELL }
  result[:fn_4] = ->(b) { say BELL }

  # copy and paste keys
  result[:ctrl_c] = ->(b) { $clipboard = b.copy; say 'copy' }
  result[:ctrl_v] = ->(b) { b.ins($clipboard); say 'paste' }
  result[:ctrl_x] = ->(b) { $clipboard = b.cut; say 'cut' }

  result[:shift_right] = ->(b) {say "lit #{b.at}"; b.set_if_not_set;  b.fwd }
  result[:shift_left] = ->(b) { b.set_if_not_set; b.back;   say "lit #{b.at}" }
  # mark set FN key
  result[:fn_4] = ->(b) {
    if b.mark_set?
      b.unset_mark
      say 'mark unset'
    else
      b.set_mark
      say 'mark set'
    end
  }
  result[:shift_up] = ->(b) { say BELL }
  result[:shift_down] = ->(b) { say BELL }
  result
end
