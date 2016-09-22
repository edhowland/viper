# describe - class Describe - command describe - echos string version of VFS node

class Describe < BaseNodeCommand
  def call *args, env:, frames:
    perform(args[0], env:env, frames:frames) {|node| env[:out].puts node.to_s }
  end
end
