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
end

