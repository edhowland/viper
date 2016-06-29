# load_path.rb - loads stuff for testing, running

require_relative 'frame_stack'
require_relative 'quoted_string'
require_relative 'string_literal'
require_relative 'glob'
require_relative 'deref'
require_relative 'assignment'
require_relative 'argument'
require_relative 'command'
require_relative 'redirection'
require_relative 'statement'
require_relative 'block'
require_relative 'pipe'
require_relative 'boolean_and'
require_relative 'boolean_or'
require_relative 'function'
require_relative 'function_declaration'
# get all the commands
Dir['./bin/*.rb'].each {|f| require_relative f }
require_relative 'visher'

require_relative 'virtual_machine'
