# buffer_writer - class BufferWriter - returned from BufNodeFacade for mode: w

class BufferWriter
  def initialize(io)
    @io = io
  end

  def buffer
    @io['buffer']
  end

  def write(contents)
    buffer.overwrite! contents
  end

  def puts(contents)
    write contents
  end

  def close
    # nop
  end
end
