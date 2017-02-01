# pipe_proc.rb - class PipeProc < Proc - wraps a Proc/Lambda with enumerable

class PipeProc < Proc
  include Enumerable

  def initialize &blk
    super &blk
    @storage = [self]
  end

  def each &blk
    @storage.each(&blk)
  end

  def | that
    @storage << that
    self
  end

  def call_with param=nil
    self.reduce(param) {|i, j| j.call(i) }
  end
end


def L &blk
  PipeProc.new &blk
end
