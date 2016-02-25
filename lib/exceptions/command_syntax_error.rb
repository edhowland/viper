# command_syntax_error.rb - exception CommandSyntaxError

class CommandSyntaxError < RuntimeError
  def initialize(message)
    super message
  end
end
