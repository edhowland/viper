# peek - class Peek - command peek - returns char of LineNode/right

class Peek < BaseNodeCommand
  def call(*args, env:, frames:)
    a = args_parse! args

    if @options[:r]
        perform(a[0], env: env, frames: frames) { |node| node[-1] }
    else
        perform(a[0], env: env, frames: frames, &:first)
    end
  end
end
