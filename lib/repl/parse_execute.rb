# parse_execute.rb - method parse_execute string, buffer

# parse_execute acommand string on a buffer
def parse_execute buffer, string
  command, *args = string.split(' ')
  command = command.to_sym
  exec_cmd command, buffer, *args
end
