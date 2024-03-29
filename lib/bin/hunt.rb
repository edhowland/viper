# hunt.rb - class Hunt - command hunt - searches array for class and 
# and rotates to found location

class Hunt < FlaggedCommand
  def initialize
    super(flags: {'-r' => false, '-t' => false}) do |inp, out, err, frames, flags, *args|
      arr, klass_s = args
      arr = Hal.open(arr, 'r').io
      klass = Kernel.const_get klass_s
      if flags['-t']
        top arr
      elsif flags['-r']
        back arr, klass
      else
        fwd arr, klass
      end
      true
    end
  end

  def fwd arr, klass
          offset = arr.index {|e| klass === e }
      if offset.zero?
        arr.rotate!
        offset = arr.index {|e| klass === e }
      end      
    arr.rotate!(offset)
  end
  def back arr, klass
    offset = arr.rindex {|e| klass === e}
    rotation = (arr.length - offset) * -1
    arr.rotate!(rotation)
  end
  def top array
    offset = array.index {|e| e.top? }
    array.rotate!  offset
  end
end