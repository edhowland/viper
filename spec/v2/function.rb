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
    frames[:_] = args   # the arguments to this function are collected in the :_ variable
    begin
      result = @block.call env:env, frames:frames
    rescue VirtualMachine::ReturnCalled => err
      result = err.return_code
    ensure
      frames.pop
    end
    result
  end
  def to_s
    "(#{@args.join(', ')}) { " + @block.to_s + " }"
  end
end
