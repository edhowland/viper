# buf_write_facade - class BufWriteFacade - returns BufWriter when open for
# write

class BufWriteFacade
  def initialize(io)
    @io = io
  end

  def mk_stream(mode)
    {
      'r' => BufferReader,
      'w' => BufferWriter,
      'a' => BufWriter
    }[mode]
  end

  def open(_path, mode)
    mk_stream(mode).new(@io)
  end
end
