# help_bindings.rb - method help_bindings - help bindings for help keys command

def identity_bindings(range)
  range.each_with_object({}) { |e, h| h["key_#{e}".to_sym] = e }
end

def punctuation_help
  [:space, :return, :tab, :period, :comma, :slash, :accent, :tilde, :exclamation, :at, :number, :dollar, :percent, :caret, :ampersand,
   :asterisk, :lparen, :rparen, :hyphen,
   :underline, :equals, :plus, :backslash, :pipe,
   :lbracket, :rbracket, :lbrace, :rbrace,
   :less, :greater, :question
  ].each_with_object({}) { |k, h| h[k] = k.to_s }
end

def control_help
  ctrl_keys = ('a'..'z').each_with_object({}) { |c, h| h["ctrl_#{c}".to_sym] = "control #{c}" }
  ctrl_keys[:ctrl_a] = 'selects the entirebuffer'
  ctrl_keys[:ctrl_h] = 'opens help in new buffer. hit control t to return to last buffer'
  ctrl_keys[:ctrl_s] = 'saves the buffer'
  ctrl_keys[:ctrl_j] = 'speaks the character to the right of the cursor'
  ctrl_keys[:ctrl_k] = 'reports the current column'
  ctrl_keys[:ctrl_l] = 'speaks the current line'
  ctrl_keys[:ctrl_f] = 'enters search buffer. hit return to search forward in the vuffer'
  ctrl_keys[:ctrl_r] = 'enters search buffer. hit return to search backward in the buffer'
  ctrl_keys[:ctrl_g] = 'search or replace  again in the last direction'
  ctrl_keys[:ctrl_q] = 'exits the editor session'
  ctrl_keys[:ctrl_t] = 'switches to next buffer (or the last one)'
  ctrl_keys[:ctrl_y] = 'yanks the current line to the clipboard'
  ctrl_keys[:ctrl_z] = 'undoes the last editor action'
  ctrl_keys[:ctrl_u] = 'redoes the last undone editor action'
  ctrl_keys[:ctrl_o] = 'opens a new line under the current line and moves there'
  ctrl_keys[:ctrl_p] = 'prints (speaks) upto the next 10 lines in the buffer'
  ctrl_keys[:ctrl_x] = 'cuts the selected text to the clipboard'
  ctrl_keys[:ctrl_c] = 'copies the selected text to the clipboard'
  ctrl_keys[:ctrl_v] = 'pastes the contents of the clipboard at the current cursor position'
  ctrl_keys[:ctrl_w] = 'Moves one word forward'
  ctrl_keys
end

def meta_help
  meta_keys = [:meta_d, :meta_colon].each_with_object({}) { |c, h| h[c] = c.to_s }
  meta_keys[:meta_d] = 'starts larger delete action. availablenext keys are: d, shift home, shift end, shift page up and shift page down'
  meta_keys[:meta_colon] = 'starts command entry. press return after a command to perform command'
  meta_keys
end

def function_help
  fkeys = ('1'..'9').each_with_object({}) { |f, h| h["fn_#{f}".to_sym] = "f #{f}" }
  decade_keys = %w(10 11 12 13 14 15).each_with_object({}) { |f, h| h["fn_#{f}".to_sym] = "f #{f}" }
  fkeys.merge!(decade_keys)
  fkeys[:fn_1] = 'opens help buffer. press control t to return to the last editing buffer'
  fkeys[:fn_2] = 'reports the name and status of the current buffer'
  fkeys[:fn_3] = 'starts keyboard help. press control q to return to editor session'
  fkeys[:fn_4] = 'sets or unsets the buffer mark. cursor movement causes selected text to be ready for cut, copy or deletion'
  fkeys
end

def arrow_help
  {
    up: 'Moves up one line',
    down: 'moves down one line',
    left: 'moves one character to left',
    right: 'moves one character to the right',
    shift_left: 'highlights one character to the left',
    shift_right: 'highlights one character to the right'
  }
end

def special_help
  {
    backspace: 'deletes one character to the left of the cursor',
    delete_at: 'deletes the character to right of the cursor',
    shift_home: 'moves to the front of the line',
    shift_end: 'moves to the end of the line',
    shift_pgup: 'moves to the top of the buffer',
    shift_pgdn: 'moves to the bottom of the buffer'
  }
end

def help_bindings
  chars = ['a'..'z', 'A'..'Z', '0'..'9'].map { |r| identity_bindings(r) }.reduce({}) { |a, e| a.merge(e) }
  chars.merge(punctuation_help).merge(control_help).merge(meta_help).merge(arrow_help).merge(function_help).merge(special_help)
end
