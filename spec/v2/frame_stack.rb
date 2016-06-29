# frame_stack - class FrameStack - holds entire stack frame  - or part of it


class FrameStack
  def initialize frames:[{}]
    @frames = frames
    @functions = {}
  end
  attr_accessor :functions
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
  def length
    @frames.length
  end
  def depth
    length
  end
end

