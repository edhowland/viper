# echo - class Echo

class Echo
  def call *args, env:

    env[:out].puts args.join(' ')
    true
  end
  
end
