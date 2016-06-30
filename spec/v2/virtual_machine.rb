# virtual_machine - class VirtualMachine - runs your stuff after parsing

class VirtualMachine
  def initialize  env:FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}]), frames:FrameStack.new
    @fs= frames
    @fs[:exit_status] = true
    @ios = env
  end
  attr_accessor :fs, :ios

  def call block
    block.call env:@ios, frames:@fs
  end
end
