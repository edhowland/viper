# recordable.rb - module Recordable

# TODO: Module documentation
module Recordable
  def init_commands
    @commands ||= CommandBuffer.new
  end

  def record_action(method, *args)
    init_commands
    @commands << [method, *args]
  end

  def record(method, *args)
    record_action(method, *args) unless @recordings_suppressed
  end

  def invert(command)
    @reverse_commands = {
      :del => :ins, :ins => :del, :fwd => :back, :back => :fwd
    }
    [@reverse_commands[command[0]], command[1]]
  end

  def undo
    init_commands
    suppress do
      last_command = @commands.back
      unless last_command.nil?
        command = invert(last_command)

        self.send(command[0], *command[1]) unless command[0] == nil
      end
    end
  end

  def redo
    init_commands
    suppress do
      command = @commands.fwd

      self.send(command[0], *command[1]) unless command.nil?
    end
  end

  def can_undo?
    init_commands
    !@commands.at_start?
  end

  def can_redo?
    init_commands
    !@commands.at_end?
  end
end
