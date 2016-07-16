# command - class Command - factory class to resolve identifiers into actual 
# runnable commands, aliases or functions

class Command
  class << self
      # fake it till you make it
    def resolve id, env:, frames:
      return Null.new if (id.nil? || id.empty?)
      id = '_break' if id == 'break'
      fn = frames.functions[id]
      return fn unless fn.nil?
      return ->(*args, env:, frames:) { frames.vm.send id.to_sym, *args, env:env, frames:frames } if frames.vm.respond_to? id.to_sym
      begin
        klass = Kernel.const_get id.to_s.capitalize
        result = klass.new
        result
      rescue => err
        env[:err].puts "Command: #{id}: not found"
        Bad.new
      end
    end
  end
end

