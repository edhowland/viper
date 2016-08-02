# exec - class Exec - command exec { block } - runs block of first arg


class Exec
  def call *args, env:, frames:
    block = args.shift
    if block.nil? || !(block.instance_of?(Block) || block.instance_of?(Lambda))
      env[:err].puts 'exec: block must be first arg'
      return false
    end
    block.call env:env, frames:frames
  end
end
