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

  def rcount_nl
    index = @buffer.rindex("\n") || 0
    @buffer.length - index
  end

  def to_s
    @buffer
  end
end
