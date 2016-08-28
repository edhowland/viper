# spy - class Spy - command spy - outputs contents of line node.left/right

class Spy < BaseNodeCommand
  def call *args, env:, frames:
        perform(args[0], env:env, frames:frames) {|node| node.join('') }
  end
end

