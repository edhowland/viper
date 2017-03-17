# suppress - class Suppress - command suppres { block } - runs block, supressing
# stdout, stderr. E.g. suppress { capture { bad_command } } captures  exceptions
# and supresses output or std error. But returns exit status
# result of stdout is stored in global :last_output
# stderr is stored in :last_error

# require_relative 'capture''
require_relative 'exec'

class Suppress < Exec
  def call(*args, env:, frames:)
    env.push
    env[:out] = StringIO.new
    env[:err] = StringIO.new
    result = super
    frames.first[:last_output] = env[:out].string
    frames.first[:last_error] = env[:err].string
    env.pop
    result
  end
end
