# line_appender - class LineAppender - returned from LineNodeFacade.open 'a'
# methods write, close, puts

class LineAppender < BaseLineHandler
  def write string
    @io.insert string
  end
  def close
    # nop
  end
  def puts string
    write "#{string}\n"
  end
end
