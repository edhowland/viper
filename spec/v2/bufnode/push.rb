# push - class Push - command push - stdin pushed onto array
# used in conjunction with deq command, ... or not


class Push < BaseNodeCommand
  def call *args, env:, frames:
    object = env[:in].read
    perform(args[0], env:env, frames:frames) {|node| node.push object; '' }
  end
end
