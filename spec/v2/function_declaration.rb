# function_declaration - class FunctionDeclaration - does: 
# function name(arg1, arg2, .. , argn) { stmnt1; stmnt2 }

class FunctionDeclaration
  def initialize name, args, block
    @name = name
    @args = args
    @block = block
  end
  def call env:, frames:
    frames.functions[@name] = Function.new(@args, @block)
    true
  end
end
