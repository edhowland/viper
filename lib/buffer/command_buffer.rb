# command_buffer.rb - class CommandBuffer track commands for undo/redo

class CommandBuffer
  def initialize
    @a_buff = []
    @b_buff= []
    @name = 'Command Buffer'
  end

  def <<(command)
    @a_buff.push command
  end

  def back
    value = @a_buff.pop
    @b_buff.unshift value
    value
  end



end
