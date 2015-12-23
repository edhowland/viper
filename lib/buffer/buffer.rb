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

  def fwd
    @a_buff.push(@b_buff.shift)
  end

  def back
    @b_buff.unshift(@a_buff.pop)
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

  def line
    lbuf = @a_buff.to_s
    rbuf = @b_buff.to_s
    prev_nl = %r{\n.*}
    next_nl = %r{^.*\n}
    lpos = prev_nl.match(lbuf).begin(0)
    rpos = next_nl.match(rbuf).begin(0)
    lbuf[lpos+1] + rbuf[rpos-1]
  end

  def to_s
    @a_buff.to_s + @b_buff.to_s
  end
end
