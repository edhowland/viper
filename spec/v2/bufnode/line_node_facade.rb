# line_node_facade - class LineNodeFacade - returns LineWriter, LineReader based
#  on mode for open


class LineNodeFacade
  def initialize io
    @io = io
  end
  def open path, mode
    if mode == 'r'
      LineReader.new @io
    elsif mode == 'w'
      LineWriter.new @io
    elsif mode == 'a'
      LineAppender.new @io
    end
  end
end
