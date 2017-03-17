# function_declaration - class FunctionDeclaration - does:
# function name(arg1, arg2, .. , argn) { stmnt1; stmnt2 }

class FunctionDeclaration
  def initialize(name, args, block, line_number = 0)
    @name = name
    @args = args
    @block = block
    @line_number = line_number
  end

  attr_reader :line_number

  def call(env:, frames:)
    frames.functions[@name] = Function.new(@args, @block, @name)
    true
  end

  def to_s
    "function #{@name}(#{@args}) { #{@block} }"
  end
end
