# mult_line_buffer.rb - class MultiLineBuffer

class MultiLineBuffer
  def initialize 
    @a_buff = [Buffer.new('')]
    @b_buff = []
  end

  def current
    @a_buff[-1]
  end

  def line
    current.line
  end

  def at
    current.at
  end

  def ins string
    current.ins string
  end

  def del string=''
    current.del string
  end

  def fwd count=1
    current.fwd count
  end

  def back count = 1
    current.back count
  end

  def front_of_line
    current.beg
  end

  def back_of_line
    current.fin
  end

  def up
    @b_buff.unshift(@a_buff.pop)
    back_of_line
  end

  def down
    @a_buff.push(@b_buff.shift)
    front_of_line
  end

  def new_line
    @a_buff << Buffer.new('')
  end
end
