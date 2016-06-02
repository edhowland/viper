# core.rb - objjects, requires for viper/core package
commands = {
  say: ->(*args, env:{}) { print args.join(' ') },
  echo: ->(*args, env:{}) { env[:out].write(args.join(' ')) }
 }

Viper::Commands::CMD_PATH.unshift commands
