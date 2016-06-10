# executor - class  Executor

class Executor
  def initialize
    
  end
  def eval obj
    if self.respond_to? obj[0]
      self.send obj[0], obj[1], obj[2]
    else
      puts obj[0]
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

