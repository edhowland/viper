# executor - class  Executor

require 'stringio'

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
  def eval obj, env:
    if self.respond_to? obj[0]
      self.send obj[0], obj[1], obj[2]
    else
      cmd, *args = obj
      command = CommandResolver[cmd]
      enviro = env.clone
      command.call(self.eval_args(*args, env:enviro), env:enviro)
      enviro[:closers].each {|f| enviro[f].close } unless enviro[:closers].nil?
    end
  end
  def execute! objs
    objs.each {|o| self.eval(o, env:@environment) }
  end
  def _and arg1, arg2
    self.eval(arg1, env:@environment) && self.eval(arg2, env:@environment)
  end
  def _or arg1, arg2
    self.eval(arg1, env:@environment) || self.eval(arg2, env:@environment)
  end
  def | arg1, arg2
    s = StringIO.new 'w'
    # set stdout to s
    enviro = @environment.clone
    enviro[:out] = s
    self.eval(arg1, env:enviro)
    # set s into stdin
    e2 = @environment.clone
    s.close_write
    s.rewind
    e2[:in] = s
    self.eval(arg2, env:e2)
  end
  def eq variable, expression
    @environment[:frames][-1][variable.to_sym] = expression
  end
  
end

