# base_buffer_command - class BaseBufferCommand - base class for Buffer methods
# given a buffer path, use class name to send method call

class BaseBufferCommand < BaseNodeCommand
  def initialize
    @meth = ->(meth, buf, arg) { buf.send meth, arg }.curry.call(command_name)
    @meth0 = ->(meth, buf) { buf.send meth }.curry.call(command_name)
  end

  def command_name
    snakeize(self.class.name).to_sym
  end
  attr_reader :meth, :meth0

  def buf_apply(arg, env:, frames:)
    perform arg, env: env, frames: frames do |node|
      buffer = node['buffer']
      yield buffer
    end
  end
end
