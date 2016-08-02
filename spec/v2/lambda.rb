# lambda - class Lambda - AST node: lambda - anonymous function


class Lambda
  def initialize args, block, frames:
    @args = args
    @block = block
    @frames = frames
  end
  def call *args, env:, frames:
    @block.call env:env, frames:@frames
  end
end
