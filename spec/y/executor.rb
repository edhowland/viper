# executor - class  Executor

class Executor
  def initialize
    # possibly init variable frame stack here
  end
  def expand_arg arg
    case arg
    when String
      arg
    when Symbol
      "-{#{arg}}-"
    when Array
      # do things like redirection or subshell invocation
    else
      fail "unexpected type of arg"
    end
  end
  
  def eval_args args=[]
    args.map {|a| expand_arg a }.reject {|e| e.nil? }
  end

  def eval obj
    if self.respond_to? obj[0]
      self.send obj[0], obj[1], obj[2]
    else
      cmd, *args = obj
      print cmd
      p self.eval_args(*args)
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
end

