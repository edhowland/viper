# lambda_declaration - class LambdaDeclaration - returns lambda closure
# returns Lambda instance

class LambdaDeclaration
  def initialize args, block
    @args = args
    @block = block
  end
  def call *args, env:, frames:
    # pull only frame stack back to function frame
    fr = frames.back(:__FUNCTION__)
    Lambda.new(@args, @block, frames:fr._clone)
  end
  def ordinal
    COMMAND
  end
  def to_s
    '&(' + @args.to_s + ') { ' + @block.to_s + ' )'
  end
end
