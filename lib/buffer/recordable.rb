# recordable.rb - module Recordable

module Recordable
  def record method, *args
    @commands ||= CommandBuffer.new
    @commands << [method, *args]
    end
  def invert command
    @reverse_commands = {
      :del => :ins, :ins => :del,  :fwd => :back, :back => :fwd
    }
    [@reverse_commands[command[0]], command[1]]
  end

  def undo
    last_command = @commands.back
    unless last_command.nil?
      command = invert(last_command)
      unless command[0] == nil
          self.send(command[0], *command[1])
      end
    end
  end



end
