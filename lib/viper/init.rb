# init.rb - method init

# init globals and other misc.
def init
load_snippets # loads snippets from ./config/snippets.JSON file
  $commands = command_bindings
  $buffer_ring = []
end
