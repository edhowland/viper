# buffer_reader - class BufferReader - returned from BufNodeFacade : mode: r

class BufferReader
  def initialize io
    @io = io
  end
  def read
    #@io.read
    buffer = @io['buffer']
    buffer.read
  end
  def close
    # nop
  end
end
