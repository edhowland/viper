# lambda - class Lambda - AST node: lambda - anonymous function

class Lambda
  # args: arg list, block: statement list, frames: context of outer environment - 
  # frames is array of hashes meant to be inserted between outer environment and local parameters and variables created here
  def initialize(args, block, frames:)
    @args = args
    @block = block
    @frames = frames
  end
  attr_reader :frames

  def call(*args, env:, frames:)
    #fr = frames + @frames # fr is now current frame stack + the saved context
#    binding.pry
fr = frames
    fr.frames += @frames
    extra = @frames.length
#    binding.pry
#    fr = frames
    fr.push
    bound = @args.zip(args).to_h # bind any passed arguments to this hash
    fr.top.merge! bound # these are now variables within this context
    # the arguments to this function are collected in the :_ variable
    fr[:_] = args
    # The number of arguments are stored in :_argc
    fr[:_argc] = args.length.to_s
    fr[:__FUNCTION_TYPE__] = 'lambda'
    fr[:__FUNCTION_NAME__] = 'anonymous'
    # Now call the parsed block we got from LambdaDeclaration
    begin
      result = @block.call env: env, frames: fr
    ensure
      fr.pop
      extra.times { fr.pop }
    end
    result 
  end

  def to_s
    '&(' + @args.join(', ') + ') ' + @block.to_s
  end
  def empty?
    false
  end
end
