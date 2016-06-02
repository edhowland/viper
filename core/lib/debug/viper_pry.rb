# viper_pry.rb - adds command to allow some debugging

Viper::Commands::CMD_PATH.unshift({ pry: ->(*args, env:{}){ binding.pry } })
