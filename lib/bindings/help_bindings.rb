# help_bindings.rb - method help_bindings - help bindings for help keys command

def identity_bindings range
  range.each_with_object({}) {|e, h| h["key_#{e}".to_sym] = e }
end

def help_bindings
  identity_bindings('a'..'z').merge(identity_bindings('A'..'Z').merge(identity_bindings('0'..'9')))
end

