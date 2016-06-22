# redirect_stdout - class RedirectStdout - > file


class RedirectStdout
  def initialize  target
    @target = target
  end
  def call frames:
    fname = @target.call frames:frames
    
  end
end

