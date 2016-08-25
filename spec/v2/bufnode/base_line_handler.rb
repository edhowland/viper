# base_line_handler.rb - class BaseLineHandler - abstract base class for:
# LineReader, LineWriter, LineAppender

class BaseLineHandler
  def initialize io
    @io = io
  end
end
