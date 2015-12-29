# viper.rb - requires for viper

# Globals # FIXME
$snippets = {}
require 'stringio'
require 'highline'

require_relative 'viper/version'
require_relative 'constants'
require_relative 'exceptions'
require_relative 'buffer'
require_relative 'ui'
require_relative 'mappings'
require_relative 'bindings'
require_relative 'io'
require_relative 'control'

require_relative 'snippets'
