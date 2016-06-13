# executor - class  Executor

require 'stringio'

class Executor
  def initialize enviro={out: $stdout, in: $stdin, err: $stderr, frames: [{}] }
    @environment =  enviro
  end
  attr_reader :environment
  # returns arg with variables deref'ed or just arg
  def deref arg, env:
      if arg[0] == :deref
            VariableDerefencer.new(env[:frames])[arg[1]]
      elsif arg[1].instance_of?(Array) && arg[1][0] == :deref
        [arg[0], VariableDerefencer.new(env[:frames])[arg[1][1]] ]
      else
        arg
      end
  end
  def expand_arg arg, env:
      return arg if String === arg
      # dereference variables
      arg = self.deref(arg, env:env) if arg[0] == :deref
      return arg if String === arg
      # do things like redirection or subshell invocation
        ArgumentResolver.new(env).resolve arg
  end

  def eval_args args=[], env:
    args.map {|a| expand_arg a, env:env }.reject {|e| e.nil? }
  end
  def eval obj, env:
    if obj[0].instance_of? Array
      self.eval(obj[0], env:env)
    else
      if self.respond_to? obj[0]
        self.send obj[0], obj[1], obj[2]
      else
        cmd, *args = obj
        command = CommandResolver[cmd]
        enviro = env.clone
        @environment[:frames][-1][:exit_status] = command.call(self.eval_args(*args, env:enviro), env:enviro)
        enviro[:closers].each {|f| enviro[f].close } unless enviro[:closers].nil?
        @environment[:frames][-1][:exit_status]
      end
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
  expression = self.deref(expression, env:@environment) if Array === expression && expression[0] == :deref
    @environment[:frames][-1][variable.to_sym] = expression
  end
  
end

