# array_reader - class ArrayReader - reads chars array

class ArrayReader
  def initialize(io)
    @io = io
  end

  def read
    @io.join('')
  end

  def close
    # nop
  end
end
