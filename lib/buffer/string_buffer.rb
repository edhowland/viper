# string_buffer.rb - class StringBuffer
# TODO: Class documentation
class StringBuffer
  def initialize(string)
    @buffer = string
  end

  def shift
    raise BufferExceeded.new('Exceeded front') if @buffer.empty?
    result = @buffer[0]
    @buffer = @buffer[1..-1]
    result
  end

  def unshift(string)
    @buffer = string + @buffer
    @buffer
  end

  def push(string)
    @buffer << string
  end

  def pop
    raise BufferExceeded.new('Exceeded back') if @buffer.empty?
    result = @buffer[-1]
    @buffer = @buffer[0..-2]
    result
  end

  def empty?
    @buffer.empty?
  end

  def [](index)
    @buffer[index]
  end

  # REMOVEME
#  def srch(regex)
#    m = regex.match @buffer
#    return @buffer if m.nil?
#    m.to_s
#  end

#  def rsrch(regexp)
#    m = regexp.match @buffer
#    return '' if m.nil?
#    m[-1]
#  end

  def lines
    io = StringIO.new @buffer
    result = []
    io.each_line { |l| result << l }
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
    @buffer[-(rcount_nl - 1)..-1]
  end

  def first_line
    @buffer[0..(count_nl)]
  end

  def length
    @buffer.length
  end

  def calc_range(limit)
    (limit < 0 ? limit..-1 : 0..(limit - 1))
  end

  def copy(limit)
    @buffer[calc_range(limit)]
  end

  def cut(limit)
    value = copy(limit)
    @buffer = if limit < 0
                @buffer[0..(limit - 1)]
              else
                @buffer[limit..-1]
              end
    value
  end

  def index(regex)
    @buffer.index regex
  end

  def rindex(regex)
    result = @buffer.rindex(regex) #- @buffer.length
    return result - @buffer.length unless result.nil?
    result
  end

  def rword_index
    offset = @buffer.rindex(/\s|\n/)

    offset = @buffer.rindex(/^\w/) if offset.nil?
    (offset.nil? ? '' : @buffer[offset..-1].lstrip)
  end

  def to_s
    @buffer
  end
end
