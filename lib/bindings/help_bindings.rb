# help_bindings.rb - method help_bindings - help bindings for help keys command

def identity_bindings range
  range.each_with_object({}) {|e, h| h["key_#{e}".to_sym] = e }
end

def punctuation_help
  [:space].each_with_object({}) {|k, h| h[k] = k.to_s }
end

def help_bindings
  ['a'..'z', 'A'..'Z', '0'..'9'].map {|r|identity_bindings(r) }.reduce({}) {|h, i| h.merge(i) } 
end

