# logger - class Logger - command logger - logs all arguments to vish.log


class Logger < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      if @options[:p]
        a[0] = "#{a[0]}:"
      end
        Log.dump(a, ' ')
    end
  end
end
