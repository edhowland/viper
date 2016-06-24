# redirect_stderr - class RedirectStderr - 2> file


class RedirectStderr < RedirectStdout
  def type_key
    :err
  end
  def to_s
    '2> ' + super
  end
end
