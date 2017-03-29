# frame_stack - class FrameStack - holds entire stack frame  - or part of it

class FrameStack
  def initialize(frames: [{}], functions: {}, aliases: {}, vm: nil)
    @frames = frames
    @functions = functions
    @aliases = aliases
    @vm = vm
  end
  attr_accessor :functions, :aliases, :vm, :frames
  def [](sym)
    result = @frames.reduce('') do |i, j|
      if j.key? sym
        j[sym]
      else
        i
      end
    end
    result # .to_s
  end

  def []=(key, value)
    @frames[-1][key] = value
  end

  # push a new frame onto the stack. Possibly for assignment
  def push
    @frames.push({})
  end

  # merge the top 2 levels on the stack, unless only one level
  def merge
    return nil if @frames.length < 2
    @frames[-2].merge! @frames[-1]
  end

  def pop
    @frames.pop
  end

  def keys
    @frames[-1].keys
  end

  def values
    @frames[-1].values
  end

  def top
    @frames[-1]
  end

  def first
    @frames.first
  end

  def length
    @frames.length
  end

  def depth
    length
  end

  def each
    @frames.each { |f| yield f }
  end

  def delete(key)
    @frames.each { |f| f.delete key }
  end

  def +(other)
    FrameStack.new(frames: @frames + other.frames, functions: other.functions, aliases: other.aliases, vm: other.vm)
  end

  def to_s
    @frames.map(&:to_s).join("\n---\n")
  end

  def index(value)
    dict = @frames.reverse.select { |e| e[value] == true }
    index = @frames.index dict.first
    index.to_i
  end

  # back: returns every from found key till top of stack in a new FrameStack
  def back(value)
    FrameStack.new(frames: @frames[(index(value))..-1], functions: @functions,
                   aliases: @aliases, vm: @vm)
  end

  def _clone
    nframes = @frames.map(&:clone)
    nfunctions = @functions.clone
    naliases = @aliases.clone
    nfs = FrameStack.new(frames: nframes,
                         functions: nfunctions, aliases: naliases)
    nfs.vm = @vm
    nfs
  end

  def slice(range)
    @frames[range]
  end
end

class IosStack < FrameStack
  def initialize
    super(frames: { in: $stdin, out: $stdout, err: $stderr })
  end
end
