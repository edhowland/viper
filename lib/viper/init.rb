# init.rb - method init

# init globals and other misc.
def init
  $snippet_cascades = {:default => {}}
  $snippet_associations = {:default => :default}
load_snippets # loads snippets from ./config/snippets.JSON file
  $commands = command_bindings
  $buffer_ring = []

  $audio_suppressed = false

  # file associations are for FileBuffer's use
  $file_associations = Association.new

  # REMOVEME
  $ruby = {}
  $spec = {}
end
