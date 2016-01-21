# init.rb - method init

# init globals and other misc.
def init
  $snippet_cascades = {:default => {}}
  $snippet_associations = {:default => :default}
#load_snippets # loads snippets from ./config/snippets.JSON file
  $commands = command_bindings
  $buffer_ring = []

  $audio_suppressed = false

  # file associations are for FileBuffer's use
  $file_associations = Association.new

  # FIXME: figure out some way to do this in .viperrc
  $file_associations.ext_lit '.rb', :ruby
  $file_associations.file_regex %r{.+_spec\.rb}, :spec

  # REMOVEME
  $ruby = {}
  $spec = {}
end
