# expand_alias.rb - method expand_alias - return command or expanded alias

def expand_alias command_s
  return command_s if Viper::Session[:alias].nil?

  key = command_s.to_sym
  (Viper::Session[:alias][key] || command_s)
end

