# command_resolver - classCommandResolver

require_relative 'echo'
require_relative 'cat'
require_relative 'fail'

class CommandResolver
  class << self
  def [] cmd
    return Echo.new if cmd == :echo
    return Cat.new if cmd == :cat
    return Fail.new if cmd == :fail
    Command.new cmd
  end
  end
end

