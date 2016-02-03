# parse_execute.rb - method parse_execute string, buffer

# strip any comments to end of line
def strip_comment(string)
  offset = string.index(/#.*$/)
  return string if offset.nil?
  return '' if offset.zero?
  string[0..offset - 1]
end

# preprocess string returning ignore if empty
def preprocess_command(string)
  string = strip_comment(string)
  return 'ignore' if string.empty?
  string
end

# parse bit
def parse_command(string)
  command, *args = string.split(' ')
  [command.to_sym, args]
end

# parse_execute acommand string on a buffer
def parse_execute(buffer, string)
  command, args = parse_command(preprocess_command(string))
  exec_cmd command, buffer, *args unless command == :ignore
end
