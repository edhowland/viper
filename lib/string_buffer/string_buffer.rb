# string_buffer.rb - class StringBuffer

class StringBuffer
  def initialize string
    @buffer = string
  end

  def shift
    result = @buffer[0]
    @buffer = @buffer[1..(-1)]
    result
  end

  def unshift string
    @buffer = string + @buffer
    @buffer
  end
  def push string
    @buffer << string
  end

  def pop
    result = @buffer[-1]
    @buffer = @buffer[0..(-2)]
    result
  end

  def empty?
    @buffer.empty?
  end

  def  [](index)
    @buffer[index]
  end

  def to_s
    @buffer
  end
end
