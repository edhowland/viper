# buf_write_facade - class BufWriteFacade - returns BufWriter when open for write


class BufWriteFacade
  def initialize io
    @io = io
  end
  def open path, mode
    if mode == 'w'
      BufWriter.new @io
    elsif mode == 'r'
      BufReader.new @io
    end
  end
end
