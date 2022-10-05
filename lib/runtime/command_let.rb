# command_let.rb: class CommandLet. Command lets are usually in /v/cmdlet/*

class CommandLet < BaseCommand
  attr_accessor :block, :code
  attr_reader :inp, :out, :err, :args, :locals, :globals
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
      return @block.call
    end
  rescue => err
    $stderr.puts err.message
  end

  def set_ios(env:)
    self.inp = env[:in]
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

  def inp=(inp)
    @inp = inp
  end
  def out=(out)
    @out = out
  end
  def err=(err)
    @err = err
  end
end
