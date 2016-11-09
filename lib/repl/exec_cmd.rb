# exec_cmd.rb - method exec_cmd

def symbol_if_colon string
  if string =~ /^:(.+)$/
    $1.to_sym
  else
    string
  end
end

def exec_cmd(command, buffer, *args)
  args = args.map { |e| deref_variables(e) }
  command_p = Viper::Session[:commands][command]
  raise CommandNotFound.new(command) if command_p.nil?
  command_p.call(buffer, *args)
end
