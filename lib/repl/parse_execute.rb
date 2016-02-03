# parse_execute.rb - method parse_execute string, buffer

# preprocess string returning ignore if empty
def preprocess_command string
  return 'ignore' if string.empty?
  string
end

# parse bit
def parse_command string
    command, *args = string.split(' ')
  [command.to_sym, args]
end

# parse_execute acommand string on a buffer
def parse_execute(buffer, string)
  command, args = parse_command(preprocess_command(string))
  exec_cmd command, buffer, *args unless command == :ignore
end
