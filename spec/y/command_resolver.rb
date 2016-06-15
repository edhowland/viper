# command_resolver - classCommandResolver - returns obj that responds to call

require_relative 'echo'
require_relative 'cat'
require_relative 'bad'

class CommandResolver
  @@storage = {}
  class << self
  def [] cmd
    return @@storage[cmd] if @@storage.has_key? cmd
    return Echo.new if cmd == :echo
    return Cat.new if cmd == :cat
    return Bad.new if cmd == :bad
    Command.new cmd
  end
  def []=(key, value)
    @@storage[key] = value
  end
  
  end
end

