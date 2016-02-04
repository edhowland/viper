# help_bindings.rb - method help_bindings - help bindings for help keys command

def identity_bindings range
  range.each_with_object({}) {|e, h| h["key_#{e}".to_sym] = e }
end

def punctuation_help
  [:space, :return, :tab, :period, :comma, :slash, :accent, :tilde, :exclamation, :at, :number, :dollar, :percent, :caret, :ampersand,
    :asterisk,:lparen, :rparen, :hyphen,
    :underline, :equals, :plus, :backslash, :pipe,
  :lbracket, :rbracket,:lbrace, :rbrace, 
    :less, :greater, :question].each_with_object({}) {|k, h| h[k] = k.to_s }
end

def control_keys
  ('a'..'z').each_with_object({}) {|c, h| h["ctrl_#{c}".to_sym] = "control #{c}" }
end

def help_bindings
  chars = ['a'..'z', 'A'..'Z', '0'..'9'].map {|r|identity_bindings(r) }.reduce({}) {|h, i| h.merge(i) } 
  chars.merge(punctuation_help).merge(control_keys)
end

