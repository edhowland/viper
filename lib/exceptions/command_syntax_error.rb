# command_syntax_error.rb - exception CommandSyntaxError

#CommandSyntaxError raised whenever the syntax of a command string was not correct. 
class CommandSyntaxError < RuntimeError
  def initialize(message)
    super message
  end
end
