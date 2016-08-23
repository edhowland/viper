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
    @frames[:_] = args   # the arguments to this function are collected in the :_ variable

    result = @block.call env:env, frames:@frames
  end
  def to_s
    '&(' + @args.to_s + ') { ' + @block.to_s + ' }'
  end
end
