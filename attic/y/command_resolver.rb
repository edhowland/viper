# command_resolver - classCommandResolver - returns obj that responds to call

require_relative 'function'
require_relative 'alias'
require_relative 'bin_loader'

class CommandResolver
  @@storage = {}
  class << self
  def [] cmd, env:{}
    return @@storage[cmd] if @@storage.has_key? cmd
    v = VariableDerefencer.new(env[:frames])
    path = v[:path]
    command_path =  "#{path}/#{cmd.to_s}"
    command= Viper::VFS.path_to_value command_path 

    unless command.nil?
      command
    else
      env[:err].puts "vish: #{cmd.to_s}: command not found"
      ->(*args, env:) { false }
    end
  end

  def []=(key, value)
    @@storage[key] = value
  end
  def keys
    @@storage.keys
  end
  def values
    @@storage.values
  end
  end
end

