# redirected_statement - class RedirectedStatement - redirect some target(s)
# and call Statement


class RedirectedStatement
  def initialize op, arg, statement
    @mode = {'>' => 'w', '<' => 'r', '>>' => 'a', '2>' => 'w'}[op]
    @key = {'>' => :out, '<' => :in, '>>' => :out, '2>' => :err}[op]
    @target = arg
    @statement = statement
  end
  def call env:, frames:
    File.open(@target.call(frames:frames), @mode) do |f|
      new_env = env.clone
      new_env[@key] = f
      @statement.call env:new_env, frames:frames
    end
  end
end
