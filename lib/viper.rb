# viper.rb - loads stuff for testing, running
require 'rake'
require 'open3'
require 'stringio'

require_relative 'api'
require_relative 'ast'
require_relative 'runtime'
require_relative 'bufnode'

# get all the commands
require_relative 'bin'

require_relative 'vish'
