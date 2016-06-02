# vish.rb - methods vish, vish! and vish_file

# namespace for Viper stuff
module Viper
  # Command stuff
  module Commands
    # commandsearch path
    # preloaded with minimum commands
    CMD_PATH = [
      exit: ->(*args, env:) { exit },
      package: ->(*args, env:{}) { package_load args[0] },
      require: ->(*args, env:{}) { require args[0] },
      set: ->(*args, env:{}) { Viper::Variables.set(args[0], args[1]) }
    ]
  end
end

# returns non-nil if command exists in CMD_PATH search space
def resolve_cmd cmd
  Viper::Commands::CMD_PATH.reduce(nil) { |i, e| i || e[cmd] }
end

# vish! parses and executes a single command
def vish! string
  sexps = parse!(string)
  sexps = dealias_sexps(sexps)
  #fail CommandNotVerified.new unless command_verified?(sexps)
  result = nil
  sexps.each do |s|
    cmd, args = s
    cmd_proc = resolve_cmd cmd
    fail "command #{cmd} not found" if cmd_proc.nil?
    args = args.map { |e| deref_variable(e) }
    cmd_proc.call *args, env:{}
    # result = exec_cmd cmd, *args
  end

  result
end

# runs a file.viper thru vish interpreter
def vish_file path
  load_rc path do |l|
    vish! l
  end
end


def vish
  loop { puts(vish!($stdin.gets)) }
end
