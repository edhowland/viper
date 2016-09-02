# pipe - class Pipe - implements stmnt1 | stmnt2 - with StringIO as buffer

class Pipe
  def initialize left, right
    @left = left
    @right=right
  end
  def call env:, frames:
    io = StringIO.new
    env.push
    env[:out] = io
    first_result = @left.call env:env, frames:frames
#binding.pry
    env.pop
    io.close_write
    io.rewind
    env.push
    env[:in] = io
    second_result = @right.call env:env, frames:frames
    env.pop
    io.close_read
    second_result
  end
  def to_s
    @left.to_s + ' | ' + @right.to_s
  end
end
