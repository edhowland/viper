# save_alias.rb - method save_alias - saves alias expansion in Viperr::Session[:alias] with symbol

def save_alias(alias_s, *args)
  key = alias_s.to_sym
  value = args.join(' ')
  return false unless syntax_ok? Buffer.new(value)
  Viper::Session[:alias] = {} if Viper::Session[:alias].nil?
  Viper::Session[:alias][key] = value
end

def report_alias(name)
  al = (Viper::Session[:alias] && Viper::Session[:alias][name])
  say al
  al
end

def delete_alias(name)
  return nil if Viper::Session[:alias].nil?
  Viper::Session[:alias].delete name.to_sym
end
