# load_path.rb - loads stuff for testing, running
require 'rake'
require_relative '../../lib/buffer'
require_relative 'ast'
require_relative 'runtime'
# get all the commands
Dir['./bin/*.rb'].each {|f| require_relative f }
require_relative 'visher'
Dir['./bufnode/*.rb'].each {|f| require_relative f }
require_relative 'version'
