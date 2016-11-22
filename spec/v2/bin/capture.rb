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
    unless exception_caught
      args[1].call(env:env, frames:frames) if (args.length >= 1 && args[1].instance_of?(Block))
    else
      args[2].call(env:env, frames:frames) if(args.length >= 2 && args[2].instance_of?(Block))
    end
    result
  end
end

