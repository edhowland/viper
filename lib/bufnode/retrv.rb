# retrv.rb: class Retrv : Opposite of class Store and /v/bin/store
# This and /v/bin/store to be moved to /v/vfs/bin  in Release 2.0.12.a



class Retrv < BaseCommand
  def call(*args, env:, frames:)
    raise VishSyntaxError.new("retrv: Expected 2 arguments, got #{args.length}") if args.length != 2
    raise VishSyntaxError.new("retrv: first argument must be a valid object in the virtual filesystem") unless (Hal.exist?(args[0]) && Hal.virtual?(args[0]))
    path, var = args
    vroot = frames[:vroot]
    
    frames[var.to_sym] = vroot[path]
    frames.merge
    return true
    
  end
end