# save_alias.rb - method save_alias - saves alias expansion in Viperr::Session[:alias] with symbol

def save_alias alias_s, *args
  key = alias_s.to_sym
  value = args.join(' ')
  Viper::Session[:alias] = {} if Viper::Session[:alias].nil?
  Viper::Session[:alias][key] = value
end

