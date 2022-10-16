# vish_runtime_error.rb: class VishRuntimeError


class VishRuntimeError < RuntimeError
  def initialize(msg="Vish Runtime error")
    super msg
  end
end
