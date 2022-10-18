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
    @block = nil
  end
  attr_accessor :block, :code
  attr_reader :inp, :out, :err, :args, :locals, :globals, :opts, :vfs
  def set_vfs(frames:)
    @vfs = Vfs.new(frames[:vroot])
  end
  def set_block
    @block = self.instance_eval('->(s) ' + @code)
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

      set_block if @block.nil?
      return @block.call(self)
  rescue => err
    $stderr.puts err.message
  end

  def set_ios(env:)
    @_env = env
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
    @_frames = frames
    @locals = frames
    @globals = frames.first
  end

  def opt
    @options
  end
  def to_s
    @code
  end
  def invoke(exe, *args)
    exe.call(*args, env: @_env, frames: @_frames)
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


# The Ruby version of cmdlet
def cmdlet(fname, flags:nil, &blk)
  vroot = get_vroot
  raise VishRuntimeError.new("cmdlet: cannot add CommandLet to virtual file system. Perhaps the VirtualMachine needs to be initialized and the VFS needs to be mounted first") if vroot.nil?
  raise VishSyntaxError.new("cmdlet:  The block for the CommandLet must not be empty. Perhaps give a block to call to cmdlet(fname, flags:nil, &blk)") unless block_given?
  clet = CommandLet.new(flags)
  clet.block = blk
  clet.code = ''
    path = default_path(fname, default: '/v/cmdlet/misc')
    vroot.creat(path, clet)
  true
end