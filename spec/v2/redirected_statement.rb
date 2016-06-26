# redirected_statement - class RedirectedStatement - redirect some target(s)
# and call Statement


class RedirectedStatement
  def initialize op, arg, statement
    @op = op
    @mode = {'>' => 'w', '<' => 'r', '>>' => 'a', '2>' => 'w'}[op]
    @key = {'>' => :out, '<' => :in, '>>' => :out, '2>' => :err}[op]
    @target = arg
    @statement = statement
  end
  def call env:, frames:
    expanded_target = @target.call frames:frames  # might be string or rarray
    actual_target = (expanded_target.instance_of?(Array) ? expanded_target[0] : expanded_target)
    File.open(actual_target, @mode) do |f|
      new_env = env.clone
      new_env[@key] = f
      @statement.call env:new_env, frames:frames
    end
  end
  def to_s
    @statement.to_s + ' ' + @op + @target.to_s
  end
end
