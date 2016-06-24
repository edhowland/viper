# redirect_stdin - class  RedirectStdin - < file

class RedirectStdin < Redirection
  def initialize  target
    super target, 'r'
  end
  def type_key
    :in
  end
  def to_s
    '< ' + super
  end
end

