# pipe - class Pipe - implements stmnt1 | stmnt2 - with StringIO as buffer



class Pipe
  def initialize left, right
    @left = left
    @right=right
  end
  def call env:, frames:
    io = StringIO.new('w')
    my_env = env.clone
    my_env[:out] = io
    first_result = @left.call env:my_env, frames:frames
    io.close_write
    io.rewind
    next_env = env.clone
    next_env[:in] = io
    second_result = @right.call env:next_env, frames:frames
  end
end
