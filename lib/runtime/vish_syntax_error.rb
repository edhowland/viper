# syntax_error.rb - class VishSyntaxError - exception raised when cannot eval
# commands

class VishSyntaxError < RuntimeError
  def initialize(msg="Vish Syntax error")
    super msg
  end
end
