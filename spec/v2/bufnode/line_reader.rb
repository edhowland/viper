# line_reader - class LineReader - returned from LineNodeFacade - open, close
# methods: read, close

class LineReader < BaseLineHandler
  def read
    @io.string
  end
  def close
    # nop
  end
end
