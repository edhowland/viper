# buffer.rb - class Buffer

class Buffer
  def initialize string
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new string
  end

  def to_s
    @a_buff.to_s + @b_buff.to_s
  end
end
