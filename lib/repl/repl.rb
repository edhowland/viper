# repl.rb - method repl reads a command string, parses it, executes it 

def repl reader=Viper::Readline.new, &blk
  string = reader.readline
  sexps = parse!(string)
  sexps = dealias_sexps(sexps)
  raise CommandNotVerified.new unless command_verified?(sexps)
  iterate_commands(sexps, &blk)
end
