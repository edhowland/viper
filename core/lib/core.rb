# core.rb - objjects, requires for viper/core package

require 'fileutils'

commands = {
  say: ->(*args, env:{}) { print args.join(' ') },
  echo: ->(*args, env:{}) { env[:out].write(args.join(' ')) },
  cat: ->(*args, env:{}) { env[:out].write(env[:in].read) }
 }

Viper::Commands::CMD_PATH.unshift commands

 # setup Viper Virtual File System
 require_relative 'vfs'
require_relative 'commands'
require_relative 'debug'
