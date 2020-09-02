# logger - class Logger - command logger - logs all arguments to vish.log
# args:
# -p prefix : adds this prefix to output with a trailing ':'
# -s Output starting log message with time of day
# -e Outputs log finish statement with time of day

class Logger < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      Log.start if @options[:s]
      a[0] = "#{a[0]}:" if @options[:p]
      Log.dump(a, ' ')
      Log.finish if @options[:e]
    end
  end
end
