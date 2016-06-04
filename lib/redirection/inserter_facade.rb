# inserter_facade - class InserterFacade

class InserterFacade
  def initialize buffer
    @buffer = buffer
  end
  def write contents
    @buffer.ins contents
  end
  
end
