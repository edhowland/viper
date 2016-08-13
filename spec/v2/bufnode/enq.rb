# enq - class Enq - command enq - stuffs stdin (arg[0]) into array node
# performs unshift operation on array
# use this command to not confuse w/shell unshift (if exists?)


class Enq < BaseNodeCommand
  def call *args, env:, frames:
    object = env[:in].read
    perform(args[0], env:env, frames:frames) {|node| node.unshift object; '' }
  end
end
