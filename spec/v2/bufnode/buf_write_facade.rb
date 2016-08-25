# buf_write_facade - class BufWriteFacade - returns BufWriter when open for write

class BufWriteFacade
  def initialize io
    @io = io
  end
  def mk_stream mode
    {
 'r' => BufReader,
 'w' => BufWriter,
 'a' => BufWriter
    }[mode]
  end
  def open path, mode
    mk_stream(mode).new(@io)
  end
end
