# pop - class Pop - command pop - extracts last element of stack - 
# used for moving within LineNode/left possibly to enq LineNode/right

class Pop < BaseNodeCommand
  def call *args, env:, frames:
    perform(args[0], env:env, frames:frames) {|node| node.pop }
  end
end

