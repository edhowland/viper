# base_buffer_command - class BaseBufferCommand - base class for Buffer methods
# given a buffer path, use class name to send method call

class BaseBufferCommand < BaseNodeCommand
  def initialize 
    @meth = ->(meth, buf, arg) { buf.send meth, arg }.curry.(self.class.name.downcase.to_sym)
  end
  attr_reader :meth
end

