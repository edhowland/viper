# exec - class Exec - command exec { block } - runs block of first arg
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity

class Exec < BaseCommand
  def call(*args, env:, frames:)
    result = true
    block = args.shift

    case block
    when Block
      result = block.call env: env, frames: frames
    when Lambda
      result = block.call(*args, env: env, frames: frames)
    when String
      root = frames[:vroot]
      node = root[block]
      if node.nil?
        env[:err].puts "exec: no such file: #{block}"
        return false
      elsif !(node.instance_of?(Lambda) || node.instance_of?(Block))
        error 'Object at',
          block, '#{block} must be a lambda function or a block'
        env[:err].puts "got: #{node.class.name}"
        return false
      end
      if node.instance_of? Block
        result = node.call(env: env, frames: frames)
      else
        result = node.call(*args, env: env, frames: frames)
      end
    when nil
      env[:err].puts 'exec: first argument must not be nil'
      return false
    else
      env[:err].puts 'exec: first argument must be either a block or lambda'
      return false
    end
    frames.merge
    result
  end
end
