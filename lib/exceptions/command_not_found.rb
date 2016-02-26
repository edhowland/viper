# command_not_found.rb - exception CommandNotFound

# CommandNotFound raised when a command was attempted, but did not exist.
class CommandNotFound < RuntimeError
  def initialize(command)
    super "Command #{command} not found"
  end
end
