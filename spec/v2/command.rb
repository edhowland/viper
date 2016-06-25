# command - class Command - factory class to resolve identifiers into actual 
# runnable commands, aliases or functions

class Command
  def initialize command_name:, arguments:ArgumentList.new([])
    @command = self.class.resolve command_name
    @args = arguments
  end
  class << self
      # fake it till you make it
    def resolve id
      klass = Kernel.const_get id.to_s.capitalize
      klass.new unless klass.nil?
    end
  end


  def call env:, frames:
    args = @args.call frames:frames   # duplicating bash behaviour
      @command.call args, env:env, frames:frames
  end
  def to_s
    @command.class.name.downcase + ' ' + @args.to_s
  end
end

