# virtual_machine - class VirtualMachine - runs your stuff after parsing

class VirtualMachine
  def initialize  env:FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}]), frames:FrameStack.new
    @fs= frames
    @fs[:exit_status] = true
    @fs.vm = self
    @fs[:pwd] = Dir.pwd
    @fs[:oldpwd] = ''
    @ios = env
  end
  attr_accessor :fs, :ios

  def call block
    block.call env:@ios, frames:@fs
  end
  def cd *args, env:, frames:
#binding.pry
    @fs.first[:oldpwd] = Dir.pwd
    Dir.chdir args[0]
        @fs.first[:pwd] = Dir.pwd
        true
  end
end
