# repl.rb - method repl reads a command string, parses it, executes it 

def perform!(string, &blk)
  sexps = parse!(string)
  sexps = dealias_sexps(sexps)
  raise CommandNotVerified.new unless command_verified?(sexps)
  iterate_commands(sexps, &blk)
end

def repl reader=Viper::Readline.new, &blk
  string = reader.readline
  perform!(string, &blk)
end
