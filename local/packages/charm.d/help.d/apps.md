Available charm subcommands

Subcommands, if any, are enclosed in square brackets like charm welcome [restore]
Every command listed below also has a [help] subcommand that is not listed.


charm status : Displays  current status of the Viper ecosystem
charm config [create] [project] [ignore] [path] [alias] : 
  Creates local  Viper/Vish config directories and .vishrc files
  Can also be used to help set your $PATH or aliases to viper and vish programs.
  It also copies a sample vishrc style template to $HOME/.config/vish/rc.
  This file can contain any settings, aliases, variables and functions
  which might override default Vish settings, et al.
charm package [ls] [new] [test] [install [path]] : 
  Lists extant, creates new, tests and installs packages
charm module [ls] [package] [new] :
  Lists known modules thatt can be imported with 'import module'
  Can use charm module package package_name to list modules within a package
  The new subcommand will create a new module and populate with some template sample files
charm welcome : [remove] [restore] :
  Displays the Viper startup banner. Or removes it or restores it at startup.
charm help displays this help text
