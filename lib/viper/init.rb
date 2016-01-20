# init.rb - method init

# init globals and other misc.
def init
  $snippet_cascades = {:default => {}}
  $snippet_associations = {:default => :default}
load_snippets # loads snippets from ./config/snippets.JSON file
  $commands = command_bindings
  $buffer_ring = []


  # REMOVEME
  $ruby = {}
  $spec = {}
end
