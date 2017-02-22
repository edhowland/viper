# deq - class Deq - command deq shift element off node and sends to stdout
# implements the shift operation on array. Use this command instead of shell 
# 'shift' command
# Possibly used in conjunction with push

class Deq < BaseNodeCommand
  def call *args, env:, frames:
    perform(args[0], env:env, frames:frames) {|node| node.shift }
  end
end

