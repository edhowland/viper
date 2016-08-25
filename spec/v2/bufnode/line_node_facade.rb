# line_node_facade - class LineNodeFacade - returns LineWriter, LineReader based
#  on mode for open

class LineNodeFacade
  def initialize io
    @io = io
  end
  def mk_stream mode
    {
      'r' => LineReader,
      'w' => LineWriter,
      'a' => LineAppender
      }[mode]
  end
  def open path, mode
  mk_stream(mode).new(@io)
  end
end
