# array_facade - class ArrayFacade - wraps Array

require_relative 'array_reader'
require_relative 'array_writer'
require_relative 'array_appender'

class ArrayFacade
  def initialize io
    @io = io
  end
  def mk_stream mode
    {
      'r' => ArrayReader,
      'w' => ArrayWriter,
      'a' => ArrayAppender
    }[mode]
  end
  def open path, mode
    mk_stream(mode).new(@io)
  end
end
