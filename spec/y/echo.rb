# echo - class Echo

class Echo
  def call *args, env:
    env[:out].puts args.join(' ')
  end
  
end
