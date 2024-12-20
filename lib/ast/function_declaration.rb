# function_declaration - class FunctionDeclaration - does:
# function name(arg1, arg2, .. , argn) { stmnt1; stmnt2 }

class FunctionDeclaration
  include ClassEquivalence

  def initialize(name, args, block, line_number = 0)
    @name = name
    @args = args
    @block = block
    @line_number = line_number
    @doc = ''
  end

  attr_reader :name, :line_number, :args, :block
  attr_accessor :doc
  def set_name(name)
    @name =  name
    self
  end

  def call(env:, frames:)
    frames.functions[@name] = Function.new(@args, @block, @name)
    frames.functions[@name].doc = @doc
    true
  end

  def to_s
    "function #{@name}(#{@args}) { #{@block} }"
  end
  def ==(other)
    class_eq(other) && (other.name.to_sym == self.name.to_sym && other.args == self.args && other.line_number == self.line_number && other.block == self.block)
  end
end
