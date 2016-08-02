# lambda - class Lambda - AST node: lambda - anonymous function


class Lambda
  def initialize args, block, frames:
    @args = args
    @block = block
    @frames = frames
  end
  def call *args, env:, frames:
    @frames.push
    bound = @args.zip(args).to_h  # bind any passed arguments to this hash
    @frames.top.merge! bound        # these are now variables within this context
    result = @block.call env:env, frames:@frames
  end
end
