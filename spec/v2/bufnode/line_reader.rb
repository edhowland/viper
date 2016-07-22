# line_reader - class LineReader - returned from LineNodeFacade - open, close
# methods.


class LineReader
  def initialize io
    @io = io
  end
  def read
    @io.string
  end
  def close
    # nop
  end
end
