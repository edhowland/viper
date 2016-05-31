# vish.rb - methods vish, vish! and vish_file

module Viper
  module Commands
    CMD_PATH = []
  end
end

def resolve_cmd cmd
  Viper::Commands::CMD_PATH.reduce(nil) { |e, i| i || e[cmd] }
end

# vish! parses and executes a single command
def vish! string
  sexps = parse!(string)
  sexps = dealias_sexps(sexps)
  fail CommandNotVerified.new unless command_verified?(sexps)
  result = nil
  sexps.each do |s|
    cmd, args = s
    fail "command #{cmd} not found" if resolve_cmd(cmd).nil?
    result = exec_cmd cmd, *args
  end

  result
end

def vish_file path
  tmp_buff = ScratchBuffer.new
  load_rc path do |l|
    perform!(l) { tmp_buff }
  end
end

