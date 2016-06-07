# editor.rb - Adds primative editor commands

Viper::Commands::CMD_PATH.unshift({
  nop: ->(*args, env:{}) { },
  repeat: ->(*args, env:{}) { env[:out].write(args[1] * args[0].to_i) },
  sol: ->(*args, env:{}) { sol args[0] },
  eol: ->(*args, env:{}) { eol args[0] },
  top: ->(*args, env:{}) { top args[0] },
  bottom: ->(*args, env:{}) { bottom args[0] },
  :+ => ->(*args, env:{}) { plus args[0] },
  :- => ->(*args, env:{}) { minus args[0] },
  down:  ->(*args, env:{}) { plusplus args[0] },
  up: ->(*args, env:{}) { minusminus args[0] }
})
