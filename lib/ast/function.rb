# function - class Function - function invocation

class Function
  def initialize(args, block, name = 'anonymous')
    @args = args
    @block = block
    @name = name
    @arity = @args.length  # The arity of this function is the number of the defined named parameters
    @doc = ''
  end
  attr_reader :name, :args, :block, :arity
    attr_accessor :doc

  def call(*args, env:, frames:)
    frames.push
    frames[:__FUNCTION__] = true
    frames[:__FUNCTION_NAME__] = @name
    frames[:__FUNCTION_TYPE__] = 'function'
    bound = @args.zip(args).to_h # bind any passed arguments to this hash
    # these are now variables within this context
    frames.top.merge! bound
    # the remaining arguments to this function are collected in the :_ variable
    frames[:_] = *args[(bound.length)..]
    # The number of arguments are stored in :_argc
    frames[:_argc] = args.length.to_s
  frames[:_arity] = @arity # The arity of the function is given in by  :_arity inside the  function call
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
  def help
    alist = "\nArgs:\n"  + @args.map {|a| "- #{a}" }.join("\n")
    "Function: #{@name}" + alist + "\n" + @doc
  end
  def inspect
    self.to_s
  end
end
