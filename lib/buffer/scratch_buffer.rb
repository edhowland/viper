# scratch_buffer.rb - class ScratchBuffer : just Recordable Buffer

# ScratchBuffer subclass of Buffer used for temp activity. Created with the new command.
class ScratchBuffer < Buffer
  include Recordable

  def initialize
    super ''
    count = $buffer_ring.count { |b| b.instance_of? ScratchBuffer }
    @name = "Scratch #{count + 1}"
  end
end
