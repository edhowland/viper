# load_path.rb - loads stuff for testing, running

require_relative 'frame_stack'
require_relative 'quoted_string'
require_relative 'string_literal'
require_relative 'element'
require_relative 'glob'
require_relative 'deref'
require_relative 'assignment'
require_relative 'assignment_list'
require_relative 'argument'
require_relative 'argument_list'
require_relative 'command'
# get all the redirection stuff
require_relative 'redirected_statement'
require_relative 'redirection'
require_relative 'statement'
require_relative 'block'
require_relative 'pipe'

# get all the commands
Dir['./bin/*.rb'].each {|f| require_relative f }
require_relative 'visher'

require_relative 'virtual_machine'