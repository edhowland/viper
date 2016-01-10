# exec_cmd.rb - method exec_cmd

def exec_cmd command, buffer, *args
  command_p = $commands[command]
  raise CommandNotFound.new(command) if command_p.nil? 
end
