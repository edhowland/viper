# deleter_facade - class DeleterFacade

class DeleterFacade
  def initialize buffer
    @buffer = buffer
  end
  def read
    @buffer.del
  end
  
end

