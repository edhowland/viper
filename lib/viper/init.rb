# init.rb - method init

# init globals and other misc.
def init
  $snippet_cascades = { :default => {} }
  $commands = command_bindings
  $buffer_ring = []

  $audio_suppressed = false

  # file associations are for FileBuffer's use
  $file_associations = Association.new
end
