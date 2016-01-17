# scratch_buffer.rb - class ScratchBuffer : just Recordable Buffer

class ScratchBuffer < Buffer
  include Recordable

  def initialize 
    super ''
    count = $buffer_ring.select {|b| b.instance_of? ScratchBuffer }.length
    @name = "Scratch #{count + 1}"
  end
end
