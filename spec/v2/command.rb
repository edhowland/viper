# command - class Command - factory class to resolve identifiers into actual 
# runnable commands, aliases or functions



class Command
  class << self
      # fake it till you make it
    def resolve id
      klass = Kernel.const_get id.to_s.capitalize
      klass.new unless klass.nil?
    end
  end
end
