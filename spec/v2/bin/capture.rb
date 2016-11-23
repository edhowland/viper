# capture - class Capture - command capture { block } - runs block, captures any
# exceptions. If present, runs next block if result is true, 
# or, if present, runs third block if result is false or exception occurred

require_relative 'exec'

class Capture < Exec
  def call *args, env:, frames:
    begin
      result = super
    rescue => err
      #env[:err].puts err.message
      env[:out].write BELL
      frames.first[:last_exception] = err.message
      exception_caught = true
      result = false
    end
      handler_clause, default_clause = args[1,2]
    if exception_caught && args.length > 1
              handler_clause.call(env:env, frames:frames)
              frames.merge
#              binding.pry
    elsif args.length == 3
      default_clause.call(env:env, frames:frames)
              frames.merge
    end

    result
  end
end

