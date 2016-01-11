# command_not_found.rb - exception CommandNotFound

class CommandNotFound < RuntimeError
  def initialize command 
    super "Command #{command} not found"
  end
end
