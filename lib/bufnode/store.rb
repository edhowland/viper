# store - class Store - command store - store &() { commands }
# /v/modes/viper/key
# stores a variable or anonymous function to a path in the VFS

class Store < BaseCommand
  def call(*args, env:, frames:)
    raise VishSyntaxError.new("store: Expected 2 arguments (object virtual_path) but got none") unless args.length == 2
    raise VishSyntaxError.new("store: Expected path of  argument to exist and be in the virtual filesystem") unless (Hal.virtual?(args[1]) && Hal.exist?(Hal.dirname(args[1])))
    object, path = args
    root = frames[:vroot]
    root.creat path, object

    true
  end
end
