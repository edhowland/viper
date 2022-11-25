# describe - class Describe - command describe - echos string version of
# VFS node

class Describe < BaseNodeCommand
  def call(*args, env:, frames:)
    if args.length != 1 || !args[0].instance_of?(String) || !Hal.virtual?(args[0])
      env[:err].puts "describe: argument error: Argument must be 1 pathname in the virtual file system"
      return false
    end
    super do |*a|
      r = frames[:vroot]
      node = r[a[0]]
      string = node.to_s
      pout string.to_s
    end
  end
end
