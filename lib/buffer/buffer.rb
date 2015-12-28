# buffer.rb - class Buffer

class Buffer
  def initialize string
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new string
  end

  def ins string
    @a_buff.push string
  end

  def del
    raise OperationNotPermitted.new('Delete past beginning of buffer') if @a_buff.empty?
    @a_buff.pop
  end

  def fwd count=1
    count.times {@a_buff.push(@b_buff.shift)}
  end

  def back count=1
    count.times {@b_buff.unshift(@a_buff.pop)}
  end

  def at
    @b_buff[0]
  end

  def beg
    @b_buff = StringBuffer.new(to_s)
  @a_buff = StringBuffer.new ''
  end

  def fin
    @a_buff = StringBuffer.new(to_s)
    @b_buff = StringBuffer.new ''
  end

  def rchomp string
    return string [1..(-1)] if string[0] == "\n"
    string
  end

  def or_empty element
    (element || '')
  end

  def lline
    or_empty(@a_buff.lines[-1])
  end

  def rline
    or_empty(@b_buff.lines[0])
  end

  def line
    lline + rline
  end

  def col
    lline.length
  end

  def up
    raise BufferExceeded.new('Cannot move past first line') if @a_buff.lines.length <= 1
    c = col
    back c + 1
    until col == c
      back
    end
  end

  def down
    raise BufferExceeded.new('Cannot move past last line') if @b_buff.lines.length <= 1
      c = col
  fwd rline.length + 2 # skip over the newline
    until col == c
      fwd
    end
  end

  def to_s
    @a_buff.to_s + @b_buff.to_s
  end
end
