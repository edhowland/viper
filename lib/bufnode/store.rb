# store - class Store - command store - store &() { commands }
# /v/modes/viper/key
# stores a variable or anonymous function to a path in the VFS

class Store < BaseCommand
  def call(*args, env:, frames:)
    object, path = args
    root = frames[:vroot]
    root.creat path, object

    true
  end
end
