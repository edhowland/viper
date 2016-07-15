# buf_write_facade - class BufWriteFacade - returns BufWriter when open for write


class BufWriteFacade
  def initialize io
    @io = io
  end
  def open path, mode
    BufWriter.new @io
  end
end
