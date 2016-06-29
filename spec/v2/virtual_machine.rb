# virtual_machine - class VirtualMachine - runs your stuff after parsing

class VirtualMachine
  def initialize 
    @fs=FrameStack.new
    @fs[:exit_status] = true
    @ios =   FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}])
  end
  attr_accessor :fs, :ios

  def call block
    block.call env:@ios, frames:@fs
  end
end
