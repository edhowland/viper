# buffer_writer - class BufferWriter - returned from BufNodeFacade for mode: w

class BufferWriter
  def initialize io
    @io  = io
  end
  def get_buffer
    @io['buffer']
  end
  def write contents
    get_buffer.overwrite! contents
  end
  def puts contents
    write contents
  end
  def close
    # nop
  end
end
