# peek - class Peek - command peek - returns char of LineNode/right


class Peek < BaseNodeCommand
  def call *args, env:, frames:
    perform(args[0], env:env, frames:frames) {|node| node.first }
  end
end
