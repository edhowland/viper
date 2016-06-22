# redirect_stderr - class RedirectStderr - 2> file


class RedirectStderr < RedirectStdout
  def type_key
    :err
  end
end
