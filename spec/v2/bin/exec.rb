# exec - class Exec - command exec { block } - runs block of first arg


class Exec
  def call *args, env:, frames:
    block = args.shift

    case block
    when Block
      block.call env:env, frames:frames
    when Lambda
      block.call *args, env:env, frames:frames
    when nil
      env[:err].puts "exec: first argument must not be nil"
      return false
    else
      env[:err].puts 'exec: block must be first arg'
      return false    
    end
  end
end
