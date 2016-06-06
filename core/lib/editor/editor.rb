# editor.rb - Adds primative editor commands

Viper::Commands::CMD_PATH.unshift({
  nop: ->(*args, env:{}) { },
  repeat: ->(*args, env:{}) { env[:out].write(args[1] * args[0].to_i) }
})
