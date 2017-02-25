# pipe - class Pipe - implements stmnt1 | stmnt2 - with StringIO as buffer
# result from last piped command is returned.
# all status are collected in the :pipe_status array

class Pipe
  def initialize left, right, line_number=0
    @left = left
    @right=right
    @line_number = line_number
  end
  attr_reader :line_number

  def call env:, frames:
    io = StringIO.new
    env.push
    env[:out] = io
    first_result = @left.call env:env, frames:frames
    left_status = frames[:pipe_status]
    env.pop
    io.close_write
    io.rewind
    env.push
    env[:in] = io
    second_result = @right.call env:env, frames:frames
    right_status = frames[:pipe_status]
    env.pop
    io.close_read
    frames.first[:pipe_status] = left_status + right_status.flatten
    second_result
  end
  def to_s
    @left.to_s + ' | ' + @right.to_s
  end
end
