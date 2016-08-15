# exec - class Exec - command exec { block } - runs block of first arg

class Exec
  def call *args, env:, frames:
    block = args.shift

    case block
    when Block
      block.call env:env, frames:frames
    when Lambda
      block.call *args, env:env, frames:frames
    when String
      root = frames[:vroot]
      node = root[block]
      if node.nil?
        env[:err].puts 'exec: no such file'
        return false
      elsif !(node.instance_of?(Lambda) || node.instance_of?(Block))
        env[:err].puts "exec: object at #{block} must be a lambda function or a block"
        env[:err].puts "got: #{node.class.name}"
        return false
      end
            node.call *args, env:env, frames:frames
    when nil
      env[:err].puts "exec: first argument must not be nil"
      return false
    else
      env[:err].puts 'exec: first argument must be either a block or lambda'
      return false    
    end
  end
end
