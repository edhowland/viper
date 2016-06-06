# core.rb - objjects, requires for viper/core package

require 'fileutils'

commands = {
  say: ->(*args, env:{}) { print args.join(' ') },
  echo: ->(*args, env:{}) { env[:out].write(args.join(' ')) },
  cat: ->(*args, env:{}) { env[:out].write(env[:in].read) }
 }

Viper::Commands::CMD_PATH.unshift commands

require_relative 'commands'
require_relative 'editor'
require_relative 'debug'
