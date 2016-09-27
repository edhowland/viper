# command - class Command - factory class to resolve identifiers into actual 
# runnable commands, aliases or functions

class Command
  class << self
    def command_from_path path, frames:
      root = frames[:vroot]
      root[path]
    end
      # fake it till you make it
    def resolve id, env:, frames:
      return Null.new if (id.nil? || id.empty?)
      id = '_break' if id == 'break'
      id = '_return' if id == 'return'

      fn = frames.functions[id]
      return fn unless fn.nil?
      return ->(*args, env:, frames:) { frames.vm.send id.to_sym, *args, env:env, frames:frames } if frames.vm.respond_to? id.to_sym
      begin
        cpath = "/v/bin/#{id}"
         thing = command_from_path cpath, frames:frames
        return thing unless thing.nil?
    # try to get old-style command from const_get of capitalized name class
        klass = Kernel.const_get id.to_s.capitalize
        result = klass.new
        result
      rescue => err
        env[:err].puts "Command: #{id}: not found"
        False.new
      end
    end
  end
end

