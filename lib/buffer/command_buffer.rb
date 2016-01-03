# command_buffer.rb - class CommandBuffer track commands for undo/redo

class CommandBuffer
  def initialize
    @a_buff = []
    @b_buff= []
    @name = 'Command Buffer'
  end

end
