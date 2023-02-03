Available charm subcommands

Subcommands, if any, are enclosed in square brackets like charm welcome [restore]
Every command listed below also has a [help] subcommand that is not listed.


charm status : Displays  current status of the Viper ecosystem
charm config [create] {vishrc] [project] : 
  Creates local  Viper/Vish config directories and .vishrc files
charm package [ls] [new] [test] [install [path]] : 
  Lists extant, creates new, tests and installs packages
charm module [ls] [package] :
  Lists known modules thatt can be imported with 'import module'
  Can use charm module package package_name to list modules within a package
charm welcome : [remove] [restore] :
  Displays the Viper startup banner. Or removes it or restores it at startup.
charm ignore  : Adds any local project's  ./vishrc to your .gitignore
charm help displays this help text
