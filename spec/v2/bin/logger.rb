# logger - class Logger - command logger - logs all arguments to vish.log


class Logger
  def call *args, env:, frames:
    Log.say(args.join(' '), '(user)')
  end
end
