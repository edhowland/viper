# syntax_error.rb - class VishSyntaxError - exception raised when cannot eval commands

class VishSyntaxError < RuntimeError
  def initialize
    super 'syntax error'
  end
end
