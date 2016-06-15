# function - class Function - functor object. responds to call binds args  vars


class Function
  def initialize name, args, expansion
    @name = name
    @args = args
    @expansion = expansion
  end
  def call *args, env:
    frame = @args.zip(args).to_h
    env[:frames].push frame
    exc = Executor.new(env)
    result = exc.execute! @expansion
    env[:frames].pop
    result
  end
end
