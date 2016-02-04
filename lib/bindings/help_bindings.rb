# help_bindings.rb - method help_bindings - help bindings for help keys command

def identity_bindings range
  range.each_with_object({}) {|e, h| h["key_#{e}".to_sym] = e }
end

def punctuation_help
  [:space, :return, :tab, :period, :comma, :slash, :accent, :tilde, :exclamation, :at, :number, :dollar, :percent, :caret, :ampersand,
    :asterisk,:lparen, :rparen, :hyphen,
    :underline, :equals, :plus, :backslash, :pipe,
  :lbracket, :rbracket,:lbrace, :rbrace, 
    :less, :greater, :question
  ].each_with_object({}) {|k, h| h[k] = k.to_s }
end

def control_keys
  ('a'..'z').each_with_object({}) {|c, h| h["ctrl_#{c}".to_sym] = "control #{c}" }
end

def meta_help
  [:meta_d, :meta_colon].each_with_object({}) {|c, h| h[c] = c.to_s }
end

def function_help
  fkeys = ('1'..'9').each_with_object({}) {|f, h| h["fn_#{f}".to_sym] = "f #{f}" }
  decade_keys = ["10", "11", "12", "13", "14", "15"].each_with_object({}) {|f, h| h["fn_#{f}".to_sym] = "f #{f}" }
  fkeys.merge(decade_keys)
end


def arrow_help
  {
    up: 'Moves up one line',
    down: 'moves down one line',
    left: 'moves one character to left',
    right: 'moves one character to the right'
  }
end

def special_help
  {
    backspace: 'deletes one character to the left of the cursor',
    shift_home: 'moves to the front of the line',
    shift_end: 'moves to the end of the line',
    shift_pgup: 'moves to the top of the buffer',
    shift_pgdn: 'moves to the bottom of the buffer'
  }
end


def help_bindings
  chars = ['a'..'z', 'A'..'Z', '0'..'9'].map {|r|identity_bindings(r) }.reduce({}) {|h, i| h.merge(i) } 
  chars.merge(punctuation_help).merge(control_keys).merge(meta_help).merge(arrow_help).merge(function_help).merge(special_help)
end

