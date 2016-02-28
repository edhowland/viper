# init.rb - method init

# init globals and other misc.
def init
  $snippet_cascades = { default: {} }
  $commands = command_bindings
  Viper::Session[:commands] =command_bindings 
  $buffer_ring = []

  $audio_suppressed = false

  # file associations are for FileBuffer's use
  $file_associations = Association.new

  # Session stuff
  Viper::Session[:intra_hooks] = [] # Procs called inside Viper::Control.loop block
  Viper::Session[:key_bindings] = make_bindings
  Viper::Session[:variables] = {} # Possible storage for command entry variables E.g. %ts

  # Package stuff
  Viper::Packages.init # instantantiates Viper::Packages::PACKAGE_PATH
end
