# function - class Function - function invocation



class Function
  def initialize args, block
    @args=args
    @block = block
  end
  def call *args, env:, frames:
    frames.push
    bound = @args.zip(args).to_h  # bind any passed arguments to this hash
    frames.top.merge! bound        # these are now variables within this context
    result = @block.call env:env, frames:frames
    frames.pop
    result
  end
end
