# command_resolver - classCommandResolver

require_relative 'echo'
require_relative 'cat'

class CommandResolver
  class << self
  def [] cmd
    return Echo.new if cmd == :echo
    return Cat.new if cmd == :cat
    Command.new cmd
  end
  end
end

