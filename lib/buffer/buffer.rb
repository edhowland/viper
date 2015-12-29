# buffer.rb - class Buffer

class Buffer
  def initialize string
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new string
    @dirty = false
    @name = 'unnamed'
  end

  attr_accessor :name

  def dirty?
    @dirty
  end


  def ins string
    @a_buff.push string
    @dirty = true
  end

  def del
    raise OperationNotPermitted.new('Delete past beginning of buffer') if @a_buff.empty?
    @dirty = true
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
    @a_buff.last_line
  end

  def rline
    @b_buff.first_line
  end

  def line
    lline + rline
  end

  def col
    lline.length
  end

  def up
    count = @a_buff.rcount_nl
    raise BufferExceeded.new('Cannot move past first line') if  count == @a_buff.length
    back count
    next_nl = @a_buff.rcount_nl
    further = next_nl - count + 1
    back(further) if further > 0
  end

  def down
    rcount = @a_buff.rcount_nl
    count = @b_buff.count_nl
    raise BufferExceeded.new('Cannot move past last line') if@b_buff.length <= count
    fwd count + 1
    next_nl = @b_buff.count_nl
    further = [next_nl, rcount].min
    fwd further
  end

  def front_of_line
    back @a_buff.rcount_nl
  end

  def back_of_line
    fwd @b_buff.count_nl
  end

  def look_ahead
    @b_buff.lines[0..9]
  end

  def to_s
    @a_buff.to_s + @b_buff.to_s
  end
end
