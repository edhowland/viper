# redirect_stdout_append - class RedirectStddoutAppend - >> file


class RedirectStdoutAppend < Redirection
  def initialize  target
    super target, 'a'
  end
  def type_key
    :out
  end
  def to_s
    '>> ' + super
  end
end
