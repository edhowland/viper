# command_resolver - classCommandResolver

require_relative 'echo'
require_relative 'cat'
require_relative 'bad'

class CommandResolver
  class << self
  def [] cmd
    return Echo.new if cmd == :echo
    return Cat.new if cmd == :cat
    return Bad.new if cmd == :bad
    Command.new cmd
  end
  end
end

