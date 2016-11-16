# perr - class Perr - command perr - redirects stdin to stderr - debugging use

class Perr < BaseCommand
  def call *args, env:, frames:
    if args.length > 0
      env[:err].puts args.join(' ')
    else
      env[:err].write(env[:in].read)
    end
    true
  end
end

