# virtual_machine - class VirtualMachine - runs your stuff after parsing


class VirtualMachine
  class << self
    def call block
      fs=FrameStack.new
      fs[:exit_status] = true
      ios =   FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}])
      block.call env:ios, frames:fs
    end
  end
end
