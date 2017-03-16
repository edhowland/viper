# sleep - class Sleep - command sleep <secs>

class Sleep < BaseCommand
  def call *args, env:, frames:
    if args.length == 1
      sleep(args[0].to_i)
    else
      arg_error 1, env:env
    end
  end
end
