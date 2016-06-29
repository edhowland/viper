# function - class Function - function invocation



class Function
  def initialize args, block
    @args=args
    @block = block
  end
  def call *args, env:, frames:
    frames.push
    result = @block.call env:env, frames:frames
    frames.pop
    result
  end
end
