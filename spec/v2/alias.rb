# alias - class Alias - alias invocation



class Alias
  def initialize expansion
    @expansion = expansion
  end
  def call *args, env:, frames:
    combined_exp = @expansion + ' ' + args.join(' ')
    block = Visher.parse! combined_exp
    block.call env:env, frames:frames
  end
end
