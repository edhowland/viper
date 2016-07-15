# buf_reader - class BufReader - recurses down nl s in BufNode, creates string


class BufReader
  def initialize io
    @io = io
  end
  def read
    @io['line'].string
  end
  def close
    # nop
  end
end
