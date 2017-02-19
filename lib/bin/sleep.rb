# sleep - class Sleep - command sleep <secs>

class Sleep < BaseCommand
  def call *args, env:, frames:
    if args.length == 1
      sleep(args[0].to_i)
    else
      env[:err].puts "sleep: wrong number of arguments: :Usage: sleep number_of_secs"
    end
  end
end
