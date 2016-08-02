# lambda_declaration - class LambdaDeclaration - returns lambda closure 
# returns Lambda instance

class LambdaDeclaration
  def initialize args, block
    @args = args
    @block = block
  end
  def call *args, env:, frames:
    Lambda.new(@args, @block, frames:frames._clone)
  end
  def ordinal
    COMMAND
  end
end

