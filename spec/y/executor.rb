# executor - class  Executor

class Executor
  def initialize
    # possibly init variable frame stack here
    @environment = {out: $stdout, in: $stdin, err: $stderr, frames: [{}] }
  end
  def expand_arg arg, env:
    case arg
    when String
      arg
    when Array
      # do things like redirection or subshell invocation
      # dereference variables
      if arg[0] == :deref
        VariableDerefencer.new(env[:frames])[arg[1]]
      elsif arg[1].instance_of?(Array) && arg[1][0] == :deref
        arg = [arg[0], VariableDerefencer.new(env[:frames])[arg[1][1]] ]

        ArgumentResolver.new(env).resolve arg
      else
        ArgumentResolver.new(env).resolve arg
      end
    else
      fail "unexpected type of arg"
    end
  end
  def eval_args args=[], env:
    args.map {|a| expand_arg a, env:env }.reject {|e| e.nil? }
  end
  def eval obj
    if self.respond_to? obj[0]
      self.send obj[0], obj[1], obj[2]
    else
      cmd, *args = obj
      command = CommandResolver[cmd]
      enviro = @environment.clone
      command.call(self.eval_args(*args, env:enviro), env:enviro)
    end
  end
  def execute! objs
    objs.each {|o| self.eval(o) }
  end
  def _and arg1, arg2
    self.eval(arg1) && self.eval(arg2)
  end
  def _or arg1, arg2
    self.eval(arg1) || self.eval(arg2)
  end
  def | arg1, arg2
    # s = StringIO.new
    # set stdout to s
    self.eval(arg1)
    # set s into stdin
    self.eval(arg2)
  end
  def eq variable, expression
    @environment[:frames][-1][variable.to_sym] = expression
  end
  
end

