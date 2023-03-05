# version - class Vish::VERSION - version of Vish shell

class Vish
  VERSION = '2.0.13.b'.freeze
  RELEASE = 'Indy: 2.1 Pre-release candidate #1'.freeze
  DESCRIPTION = <<-EOD.freeze
Viper version #{Vish::VERSION}
Runs scripts in the Vish command language  implement a code editor.
The editor scripts are in the Viper Home/scripts directory. Each is a numbered
file (E.g.: 001_editor.vsh, 002_*.vsh).
Use -h to see a list of options. By default, viper will open a
buffer called : unnamed1
Any non option arguments are treated as files to be edited.
Use the --mode mode option to start another mode besides : vip.
-m com  : starts the command REPL.
--mode nop  : Will run nothing at start.
--mode userfn  : Will run any function you choose.

Use the --source to load your own list of Vish scripts or use --execute
to load a script on the command line.
  EOD
end
