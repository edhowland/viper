# command.rb - method command - parses command, possibly expanding aliases

def expand_commands commands
  commands.split(/ *; */).map do |cmd|
    cmd = expand_alias(cmd)
    if cmd =~ /;/
      expand_commands(cmd)
    else
      cmd
    end
  end.flatten
end

def command command_s, &blk
  expand_commands(command_s).each do |cmd|
    yield cmd if block_given?
  end
end

