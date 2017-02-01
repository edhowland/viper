# decorated_proc - class DecoratedProc - decorate Proc objects with message

class DecoratedProc < Proc
  attr_accessor :message
  def inspect
    message
  end
end
