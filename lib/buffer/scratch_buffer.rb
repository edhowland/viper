# scratch_buffer.rb - class ScratchBuffer : just Recordable Buffer

class ScratchBuffer < Buffer
  include Recordable

  def initialize 
    super ''
    count = $buffer_ring.count {|b| b.instance_of? ScratchBuffer }
    @name = "Scratch #{count + 1}"
  end
end
