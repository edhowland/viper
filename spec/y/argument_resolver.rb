# argument_resolver - class ArgumentResolver

class ArgumentResolver
  def initialize environment
    @environment = environment
    @environment[:closers] = []
  end
  def resolve arg
    action, *args = arg
    self.send action, *args
  end
  def redirect_from *args
    @environment[:in] = File.open(args[0])
    @environment[:closers] << :in
    nil # consume this arg
  end
  def redirect_to *args
    @environment[:out] = File.open(args[0], 'w')
    @environment[:closers] << :out
    nil
  end
  def append_to *args
    @environment[:out] = File.open(args[0], 'a')
    @environment[:closers] << :out
    nil
  end
  
  
  
  def method_missing name, *args
    @environment[:err].puts "Do not know how to resolve #{name}"
  end
end

