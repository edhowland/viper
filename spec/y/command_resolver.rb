# command_resolver - classCommandResolver
 
class CommandResolver
  class << self
  def [] cmd
    Command.new cmd
  end
  end
end

