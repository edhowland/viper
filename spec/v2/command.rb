# command - class Command - factory class to resolve identifiers into actual 
# runnable commands, aliases or functions

class Command
  class << self
      # fake it till you make it
    def resolve id
      return Null.new if (id.nil? || id.empty?)
      begin
        klass = Kernel.const_get id.to_s.capitalize
        result = klass.new
        result
      rescue => err
        $stderr.puts "Command: #{id}: not found"
        Bad.new
      end
    end
  end
end

