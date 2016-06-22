# frame_stack - class FrameStack - holds entire stack frame  - or part of it


class FrameStack
  def initialize frames:[{}]
    @frames = frames
  end
    def [] sym
    result = @frames.reduce('') do |i, j|
      j[sym] || i 
    end
    result.to_s
  end
  def []= key, value
    @frames[-1][key] = value
  end
  # push a new frame onto the stack. Possibly for assignment
  def push
    @frames.push({})
  end
  # pop the last frame (presumably the assignment frame) and merge it back to the
  # previous frame
  def pop_and_store
    locals = @frames.pop
    @frames[-1].merge! locals
  end
end

