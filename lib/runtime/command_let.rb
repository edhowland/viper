# command_let.rb: class CommandLet. Command lets are usually in /v/cmdlet/misc/*
#  That is the path

class CommandLet
  class Vfs
    def initialize vroot
      @vroot = vroot
    end
    attr_reader :vroot
    def [] path
      @vroot[path]
    end
    def []= path, obj
      @vroot.creat(path, obj)
    end
  end
  def initialize(flags=nil)
    @opts = Hash.new { false }
    @optparse = nil
    unless flags.nil?
      @optparse = optparse_from flags
    end
  end
  attr_accessor :block, :code
  attr_reader :inp, :out, :err, :args, :locals, :globals, :opts, :vfs
  def set_vfs(frames:)
    @vfs = Vfs.new(frames[:vroot])
  end
  def set_block
    @block = self.instance_eval('->() ' + @code)
  end
  def self.valid_flags?(csv)
    !! /([a-zAZ]:?)(,\1)*/.match(csv)
  end
  def self.from_s(code)
    rcode = self.name + '.new ' + code
    return rcode
  end
  def call(*args, env:, frames:)
      set_args args
      set_ios(env: env)
      set_vars(frames: frames)
      set_vfs(frames: frames)

      set_block
      return @block.call
  rescue => err
    $stderr.puts err.message
  end

  def set_ios(env:)
    self.inp = env[:in]
    self.out = env[:out]
    self.err = env[:err]
  end
  def set_args args
  @optparse.parse!(args, into: @opts) unless @optparse.nil?

    @args = args
  end
  def argc
    @args.length
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
  # TODO: remove valid_opt?
  def valid_opt?(ch)
    ch.length == 2 && ch[1] == ':'
  end

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
