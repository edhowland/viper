# executor - class  Executor

require 'stringio'

class Executor
  def initialize enviro={out: $stdout, in: $stdin, err: $stderr, frames: [{path: '/viper/bin', exit_status: true}] }
    @environment =  enviro
  end
  attr_reader :environment

  def expand_arg arg, env:
    result = ArgumentResolver.new(env).resolve arg
    unless result.nil?
      v = VariableDerefencer.new(env[:frames])
      v.interpolate_str result
    else
      result
    end
  end

  def eval_args args=[], env:
    args.map {|a| expand_arg a, env:env }.reject {|e| e.nil? }
  end
  def eval obj, env:
    if obj[0].instance_of? Array
      self.eval(obj[0], env:env)
    else
      if self.respond_to? obj[0]
        self.send(obj[0], *(obj[1..(-1)]), env:env)
      else
        cmd, *args = obj
        enviro = env.clone

        command = CommandResolver[cmd, env:enviro]
        @environment[:frames][-1][:exit_status] = command.call(self.eval_args(*args, env:enviro), env:enviro)
        enviro[:closers].each {|f| enviro[f].close } unless enviro[:closers].nil?
        @environment[:frames][-1][:exit_status]
      end
    end
  end
  def execute! objs
    objs.each {|o| self.eval(o, env:@environment) }
    @environment[:frames][-1][:exit_status]
  end
  def _and arg1, arg2, env:
    self.eval(arg1, env:@environment) && self.eval(arg2, env:@environment)
  end
  def _or arg1, arg2, env:
    self.eval(arg1, env:@environment) || self.eval(arg2, env:@environment)
  end
  def | arg1, arg2, env:
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

  def eq variable, expression, env:
  expression = self.expand_arg(expression, env:@environment)
    @environment[:frames][-1][variable.to_sym] = expression
  end
  def _alias name, expansion, env:
    al = Alias.new name, expansion
    CommandResolver[name] = al
    true
  end
  def _expand_alias name, env:
    thing = CommandResolver[name]
    if thing && Alias === thing
      env[:out].puts "alias #{thing.name}=\"#{thing.expansion}\""
      true
    else
      env[:err].puts "vish: alias: #{name} not found"
      false
    end
  end
  def _list_alias env:
    CommandResolver.values.select {|e| Alias === e }.each do |e|
      env[:out].puts "alias #{e.name}=\"#{e.expansion}\""
    end
  end


  def fn functor, env:
    CommandResolver[functor.name] = functor
    @environment[:frames][-1][:exit_status] = true
  end
end

