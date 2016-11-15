# version - class Vish::VERSION - version of Vish shell

class Vish
  VERSION = '0.2.0'.freeze
  DESCRIPTION = <<-EOD
  Vish is an Bash-like command shell developed for the Viper editor.
  Thi version #{VERSION} contains support for the Buffer class API and
  the implementation of the Viper written entirely in various Vish scripts:
  etc/vishrc - Vish startup script: mounts /v as root of all data structures
  editor.vsh - Supporting functions for editors
  viper.vsh - The key bindings for editor mode: viper
  EOD
end

