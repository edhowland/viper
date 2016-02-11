# command.rb - method command - parses command, possibly expanding aliases

def command command_s, &blk
  yield command_s if block_given?
end

