def mkenv
  FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}])
end

def m
  return mkenv, FrameStack.new
end
def p s
  Visher.parse! s
end

# monkey patch Block so we can get some statement from @statement_list
class Block
  def [] index
    @statement_list[index]
  end
end
