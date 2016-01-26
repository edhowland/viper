# command_not_found.rb - exception CommandNotFound

# TODO: Class documentation
class CommandNotFound < RuntimeError
  def initialize(command) 
    super "Command #{command} not found"
  end
end
