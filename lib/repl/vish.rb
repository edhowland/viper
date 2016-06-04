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

# chucks out any redirects from arguments
# yields to the block with operator and pathname if in ops array
def apply_redirects args, &blk
  ops = ['<', '>', '>>']
  stack = []
  args.reverse.each do |e|
    if ops.member? e
      path = stack.pop
      yield e, path if block_given?
    else
      stack.push e
    end
  end
  stack.reverse
end

# returns non-nil if command exists in CMD_PATH search space
def resolve_cmd cmd
  Viper::Commands::CMD_PATH.reduce(nil) { |i, e| i || e[cmd] }
end

# vish! parses and executes a single command
def vish! string
  sexps = parse!(string)
  Viper::Variables[:exit_status] = true
  sexps = dealias_sexps(sexps)
  #fail CommandNotVerified.new unless command_verified?(sexps)
  result = nil
  sexps.each do |s|
    cmd, args = s
    cmd_proc = resolve_cmd cmd
    fail "command #{cmd} not found" if cmd_proc.nil?
    args = args.map { |e| deref_variable(e) }
    begin
      enviro = {in: $stdin, out: $stdout}

      args = apply_redirects(args) do |op, path|
        if op == '>'
          enviro[:out] = Viper::VFS.open_for_write(path)  # File.open(path, 'w')
        elsif op == '<'
          enviro[:in] = Viper::VFS.open_for_read(path)  # File.open path
        end
      end

    result = cmd_proc.call *args, env:enviro

    rescue => err
      puts err.message
    ensure
      enviro[:in].close if File=== enviro[:in] 
      enviro[:out].close if File=== enviro[:out] 
    end
  Viper::Variables[:exit_status] = result
  end

  nil
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
