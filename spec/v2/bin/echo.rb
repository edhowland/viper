# echo - class Echo

class Echo
  def spit args
    args.join(' ')
  end
  def call *args, env:, frames:
    if args[0] == '-n'
      env[:out].write spit(args[1..(-1)])
    else
      env[:out].puts spit(args)
    end
    true
  end
  
end
