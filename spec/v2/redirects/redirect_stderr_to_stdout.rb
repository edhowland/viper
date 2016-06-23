# redirect_stderr_to_stdout - class RedirectStderrToStdout - implements: 2>&1

# This simulates RedirectStderr, but instead returns stdout (or whatever
# RedirectStdout is set to. Or RedirectStdoutAppend.
# It does not close the File handle.
class RedirectStderrToStdout < Crossover
  def initialize 
    super $stdout, :out
  end
  def type_key
    :err
  end
end
