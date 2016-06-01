# core.rb - objjects, requires for viper/core package
commands = {
  say: ->(*args) { print args.join(' ') }
 }

Viper::Commands::CMD_PATH.unshift commands
