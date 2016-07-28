# not - class Not - command not expression - inverts truth of expression

class Not
  def call *args, env:, frames:
    block = args.shift
    if block.nil? || !block.instance_of?(Block)
      env[:err].puts 'not: first arg must be a block'
      return false
    end
    !block.call env:env, frames:frames
  end
end

