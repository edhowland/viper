# register.rb - class  Register - handle Vim like registers

class Register
  def initialize
    @tiny = ''
    @r0 = ''
    @r = Array.new(9, '')
    @n = Array.new(26, '')
  end
  attr_reader :tiny, :r0, :r, :n
  def tiny=(val)
    @tiny = val
  end

  def r0=(val)
    @r0 = val
  end
  def r1
    @r[0]
  end
  def r1=(val)
    @r.unshift(val)
    @r.pop
  end
end


$registers = Register.new
