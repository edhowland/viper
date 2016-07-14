# frame_stack - class FrameStack - holds entire stack frame  - or part of it


class FrameStack
  def initialize frames:[{}], functions:{}, aliases:{}
    @frames = frames
    @functions = functions
    @aliases = aliases
    @vm = nil
  end
  attr_accessor :functions, :aliases, :vm
    def [] sym
    result = @frames.reduce('') do |i, j|
    if j.has_key? sym
        j[sym]
      else
        i
      end
    end
    result  #.to_s
  end
  def []= key, value
    @frames[-1][key] = value
  end
  # push a new frame onto the stack. Possibly for assignment
  def push
    @frames.push({})
  end
  # merge the top 2 levels on the stack
  def merge
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
  def each &blk
    @frames.each {|f| yield f }
  end
  def _clone
    nframes = @frames.map {|e| e.clone }
    nfunctions = @functions.clone
    naliases = @aliases.clone
    nfs = FrameStack.new(frames:nframes, functions:nfunctions, aliases:naliases)
    nfs.vm = @vm
    nfs
  end
end

