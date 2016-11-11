# capture - class Capture - command capture { block } - runs block, captures any
# exceptions
require_relative 'exec'
class Capture < Exec
  def call *args, env:, frames:
    begin
      result = super
    rescue => err
      env[:err].puts err.message
      result = false
    end
    result
  end
end

