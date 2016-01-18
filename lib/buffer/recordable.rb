# recordable.rb - module Recordable
module Recordable
  def record_action method, *args
    @commands ||= CommandBuffer.new
    @commands << [method, *args]
    end

  def record method, *args
    record_action(method, *args) unless @recordings_suppressed
  end

  def invert command
    @reverse_commands = {
      :del => :ins, :ins => :del,  :fwd => :back, :back => :fwd
    }
    [@reverse_commands[command[0]], command[1]]
  end

  def undo
    suppress do
      last_command = @commands.back
      unless last_command.nil?
        command = invert(last_command)
        unless command[0] == nil
          self.send(command[0], *command[1])
        end
      end
    end

  def redo
    suppress do
      command = @commands.fwd
      unless command.nil?
        self.send(command[0], *command[1])
      end
    end
  end

  end

end
