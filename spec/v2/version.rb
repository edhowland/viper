# version - class Vish::VERSION - version of Vish shell

class Vish
  VERSION = '0.2.5'.freeze
  DESCRIPTION = <<-EOD
  Vish is an Bash-like command shell developed for the Viper editor.
  Thi version #{VERSION} contains support for the Buffer class API and
  the implementation of the Viper written entirely in various Vish scripts:
  etc/vishrc - Vish startup script: mounts /v as root of all data structures
  scripts/editor.vsh - Supporting functions for editors
  scripts/eviper.vsh - The key bindings for editor mode: viper
  scripts/edelete.vsh - deletion commands, bound to meta_d + keys
  scripts/eprompt.vsh - prompting for a choice from user
  scripts/ecommand.vsh - command mode invoked with meta_semicolon
  meta.vsh - function meta - loop about meta mode.
  startup.vsh - gets the whole ball rolling. drops into meta mode with either
    vip or com mode
  shutdown.vsh - cleans up unsaved buffers asking to save them.
  debug.vsh - various aliases for debugging
scripts/ruby.vsh prehook and extension setup for Ruby language snippets
scripts/vish.vsh pre_hook for .vsh file type
ruby.json snippets for Ruby language. Load with loadrb, save macros with dumprb
vish.json snippets for .vsh: Vish file types. load w/loadvsh, dump w/dumpvsh
scripts/extras.vsh empty placeholder fo extra functions as needed
scripts/marks.vsh - functions  for use in navigating marks set in :_mark
scripts/macros.vsh - functions having to do with macros : save_macro, play_macro, edit_macro, rm_macro, macros
  EOD
end

