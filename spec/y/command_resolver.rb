# command_resolver - classCommandResolver - returns obj that responds to call

require_relative 'function'
require_relative 'alias'
require_relative 'echo'
require_relative 'cat'
require_relative 'bad'
require_relative 'source'
require_relative 'bye'
require_relative 'pry_invoker'
require_relative 'debug'

class CommandResolver
  @@storage = {}
  class << self
  def [] cmd
    return @@storage[cmd] if @@storage.has_key? cmd
    return Bye.new if cmd == :bye
    return PryInvoker.new if cmd == :pry
    return Debug.new if cmd == :debug
    return Source.new if cmd == :source
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

