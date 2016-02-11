# expand_alias.rb - method expand_alias - return command or expanded alias

def expand_alias command_s
  return command_s if Viper::Session[:alias].nil?

  cmd, *args = command_s.split(/\s+/)
  key = cmd.to_sym
  value = Viper::Session[:alias][key]
  (value ? ([value] + args).join(' ') : command_s)
end

