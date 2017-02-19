# pry_invoker - class PryInvoker

class PryInvoker
  def call *args, env:, frames:
    binding.pry
  end
end

