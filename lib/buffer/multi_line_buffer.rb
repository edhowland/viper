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


end
