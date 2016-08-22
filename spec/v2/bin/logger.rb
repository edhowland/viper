# logger - class Logger - command logger - logs all arguments to vish.log


class Logger < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      if @options[:p]
        prefix = a.shift
        Log.say(a.join(' '), prefix)
      else
        Log.say(a.join(' '))
      end
    end
  end
end
