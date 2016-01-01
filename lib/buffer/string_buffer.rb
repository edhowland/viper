# string_buffer.rb - class StringBuffer

class StringBuffer
  def initialize string
    @buffer = string
  end

  def shift
    raise BufferExceeded.new('Exceeded front') if @buffer.empty?
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
    raise BufferExceeded.new('Exceeded back') if @buffer.empty?
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

  def srch regex
    m = regex.match @buffer
    return @buffer if m.nil?
    m.to_s
  end

  def rsrch regexp
    m=regexp.match @buffer
    return '' if m.nil?
    m[-1]
  end

  def lines
    io = StringIO.new @buffer
    result = []
    io.each_line {|l| result << l}
    result
  end

  def count_nl
    index = @buffer.index("\n")
    index || length
  end

  def rcount_nl
    index = @buffer.rindex("\n") || 0
    @buffer.length - index
  end

  def last_line
    return '' if @buffer[-1] == "\n"
    return @buffer if rcount_nl == length
    @buffer[-(rcount_nl - 1)..(-1)]
  end

  def first_line
    @buffer[0..(count_nl)]
  end


  def length
    @buffer.length
  end

  def copy limit
    @buffer[0..(limit - 1)]
  end

  def to_s
    @buffer
  end
end
