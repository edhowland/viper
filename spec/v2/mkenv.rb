def mkenv
  {in: $stdin, out: $stdout, err: $stderr}
end


def m
  return mkenv, FrameStack.new
end
def p s
  Visher.parse! s
end
