# lambda - class Lambda - AST node: lambda - anonymous function

class Lambda
  # args: arg list, block: statement list, frames: context of outer environment
  def initialize args, block, frames:
    @args = args
    @block = block
    @frames = frames
  end

  def call *args, env:, frames:
    fr = frames + @frames   # fr is now current frame stack + the saved context
    fr.push
    bound = @args.zip(args).to_h  # bind any passed arguments to this hash
    fr.top.merge! bound        # these are now variables within this context
    fr[:_] = args   # the arguments to this function are collected in the :_ variable
    fr[:_argc] = args.length.to_s  # The number of arguments are stored in :_argc
    result = @block.call env:env, frames:fr
  end

  def to_s
    '&(' + @args.join(', ') + ') ' + @block.to_s
  end
end
