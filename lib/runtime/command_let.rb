# command_let.rb: class CommandLet. Command lets are usually in /v/cmdlet/*

class CommandLet < BaseCommand
  attr_accessor :block, :code
  attr_reader :in, :out, :err, :args, :locals, :globals
  def set_block
    @block = self.instance_eval('->() ' + @code)
  end
  def self.from_s(code)
    rcode = self.name + '.new ' + code
    return rcode
  end
  def call(*args, env:, frames:)
    super do
      set_args args
      set_ios(env: env)
      set_vars(frames: frames)
      set_block
      @block.call
    end
  end

  def set_ios(env:)
    self.in = env[:in]
    self.out = env[:out]
    self.err = env[:err]
  end
  def set_args args
    @args = args
  end
  def set_vars(frames:)
    @locals = frames
    @globals = frames.first
  end

  def opt
    @options
  end
  def to_s
    @code
  end
  
  private

  def in=(inp)
    @in = inp
  end
  def out=(out)
    @out = out
  end
  def err=(err)
    @err = err
  end
end
