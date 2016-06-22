# echo - class Echo

class Echo
  def call *args, env:, frames:
    env[:out].puts args.join(' ')
    true
  end
  
end
