# argument_resolver - class ArgumentResolver

class ArgumentResolver
  def initialize environment
    @environment = environment
  end
  def resolve arg
    action, *args = arg
    self.send action, *args
  end
  def deref *args
    VariableDerefencer.new(@environment[:frames])[args[0]]
  end
  def method_missing name, *args
    @environment[:err].puts "Do not know how to resolve #{name}"
  end
end

