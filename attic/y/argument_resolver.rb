# argument_resolver - class ArgumentResolver

class ArgumentResolver
  def initialize environment
    @environment = environment
    @environment[:closers] = []
    @stack = []
  end
  attr_accessor :stack
  def stacker arg
    if Array === arg
      arg.flatten.reverse.each {|e| @stack.push e }
    else
      @stack.push arg
    end
  end
  def unstacker
    expr = @stack.pop
    if self.respond_to? expr
      self.send(expr, unstacker)
    else
      expr
    end
  end
  def deref arg
    VariableDerefencer.new(@environment[:frames])[arg]
  end
  
  
  
  def resolve arg
    self.stacker arg
    self.unstacker
  end
  # interpolate redirection targets
  def interpolate arg
    v=VariableDerefencer.new @environment[:frames]
    v.interpolate_str arg
  end

  # start of redirection methods
  def redirect_from arg
    arg = interpolate arg
    @environment[:in] = File.open(arg)
    @environment[:closers] << :in
    nil # consume this arg
  end
  def redirect_to arg
    arg = interpolate arg
    @environment[:out] = File.open(arg, 'w')
    @environment[:closers] << :out
    nil
  end
  def append_to arg
    arg = interpolate arg
    @environment[:out] = File.open(arg, 'a')
    @environment[:closers] << :out
    nil
  end
  def redirect_err arg
    arg = interpolate arg
    @environment[:err] = File.open(arg, 'w')
    @environment[:closers] << :err
    nil
  end
  
  
  # evaluate subshell expansion by calling a new Executor.new and .execute!
  # takes a Statement object - constructed by parser
  def _eval statement_obj
    statement = statement_obj.statement
    sio = StringIO.new 'w'
    executor = Executor.new({in: $stdin, out: sio,  err: $stderr, frames: @environment[:frames] })
    executor.execute! statement
    sio.close_write
    sio.string.chomp
  end
  def respond_to? obj
    return false unless Symbol === obj || String === obj
    super
  end
  


  def method_missing name, *args
    @environment[:err].puts "Do not know how to resolve #{name}"
  end
end

