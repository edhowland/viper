# enq - class Enq - command enq - stuffs stdin (arg[0]) into array node


class Enq < BaseNodeCommand
  def call *args, env:, frames:
    object = env[:in].read
    perform(args[0], env:env, frames:frames) {|node| node.unshift object; '' }
  end
end
