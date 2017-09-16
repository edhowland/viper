# function - class Function - function invocation

class Function
  def initialize(args, block, name = 'anonymous')
    @args = args
    @block = block
    @name = name
  end

  attr_reader :name

  def call(*args, env:, frames:)
    frames.push
    frames[:__FUNCTION__] = true
    frames[:__FUNCTION_NAME__] = @name
    frames[:__FUNCTION_TYPE__] = 'function'
    bound = @args.zip(args).to_h # bind any passed arguments to this hash
    # these are now variables within this context
    frames.top.merge! bound
    # the arguments to this function are collected in the :_ variable
    frames[:_] = args
    # The number of arguments are stored in :_argc
    frames[:_argc] = args.length.to_s
    begin
      result = @block.call env: env, frames: frames
    rescue VirtualMachine::ReturnCalled => err
      result = err.return_code
    ensure
      frames.pop
    end
    result
  end

  def to_s
    "(#{@args.join(', ')}) " + @block.to_s
  end
end
