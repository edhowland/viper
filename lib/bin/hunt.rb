# hunt.rb - class Hunt - command hunt - searches array for class and 
# and rotates to found location

class Hunt < FlaggedCommand
  def call(*args, env:, frames:)
    arr, klass_s = args
    arr = Hal.open(arr, 'r').io
    klass = Kernel.const_get klass_s
    offset = arr.index {|e| klass === e }
    if offset.zero?
      arr.rotate!
      offset = arr.index {|e| klass === e }
    end
    arr.rotate!(offset)
    true
  end
end