# wc - class Wc - command wc - like the bash one
# possible future args:
# -c [default] : prints the character count of the stdin
# -w : prints the word count of the stdin
# -l prints the line count of stdin
# -n  prints w/o newline


class Wc
  def call *args, env:, frames:
    method = :puts
    if args.length > 0
      method = :print if args[0] == '-n'
    end
    env[:out].send(method, env[:in].read.length)
    true
  end
end
