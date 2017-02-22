# pry_invoker - class PryInvoker

class PryInvoker
  def call *args, env:
    binding.pry
  end
  
end

