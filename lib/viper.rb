# viper.rb - requires for viper

# Globals # FIXME
$snippets = {}
$commands = {}
$clipboard = ''
$buffer_ring = []

# std requires
require 'stringio'
require 'json'
require 'open3'

require_relative 'viper/version'
require_relative 'viper/init'
require_relative 'constants'
require_relative 'exceptions'
require_relative 'buffer'
require_relative 'ui'
require_relative 'mappings'
require_relative 'bindings'
require_relative 'io'
require_relative 'control'
require_relative 'snippets'
require_relative 'readline'
require_relative 'system'
require_relative 'repl'


# init some stuff
init