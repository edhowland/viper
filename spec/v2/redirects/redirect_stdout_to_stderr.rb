# redirect_stdout_to_stderr - class RedirectStdoutToStderr - implements >&1

class RedirectStdoutToStderr < Crossover
  def initialize 
    super $stderr, :err
  end
  def type_key
    :out
  end
  def to_s
    '>&1'
  end
end
