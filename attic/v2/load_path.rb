# load_path.rb - loads stuff for testing, running
require 'rake'
require 'open3'

require_relative 'api'
require_relative 'ast'
require_relative 'runtime'
require_relative 'bufnode'

# get all the commands
Dir['./bin/*.rb'].each {|f| require_relative f }
require_relative 'visher'
require_relative 'version'
