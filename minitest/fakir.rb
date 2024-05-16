# class Fakir to mock a PhysicalLayer and function to wrap Hal.set_filesystem

class Fakir

  @current_arity = 0
      def _arity(name)
      @current_arity
    end


  def initialize(meth, inp=[], out=nil)
    @meth = meth
    @inp = inp
    @current_arity = @inp.length
    @out = out

    # record run statuses
    @result = {meth: false, inp: false}
  end
  def method_missing(name, *args)

    @result[:meth] = (@meth == name)
    @result[:inp] = (@inp == args)

    @out
  end
  def verify!


    @result.values.reduce(true) {|i,j| i && j } 
  end
end

# Makes sure Hal filesystem @@p_layer is saved and preserved
def run_safe(testr, meth, inp=[], out=nil, &blk)
  old_player = Hal.get_filesystem
  new_player = Fakir.new(meth, inp, out)

  Hal.set_filesystem(new_player)
  yield
  Hal.set_filesystem(old_player)
  testr.assert(new_player.verify!)
end



# This version will simulate raising an error like ArgumentError
class FakirErr  
  @current_arity = 0

    def _arity(name)
      @current_arity
    end

  def initialize(meth, args, err)
    @meth = meth
    @args = args
    @current_arity = @args.length
    @err = err
  end

  # fake this out because VirtualLayer relies on Hal.pwd which is missing when Fakir-ed
  def pwd
    Dir.pwd
  end

  def method_missing(name, *args)
    if name == @meth
      raise @err.new
    else
      raise RuntimeError.new("Incorrect call to #{self.class.name} -> #{name} : Unknown method name, did you mean #{@meth}")
    end
  end
  def respond_to_missing?(name, private = false)
    name == @meth
  end
end


# catch and kill an error for this mock
def katch(testr, meth, args, err, &blk)
  old_player = Hal.get_filesystem
  new_player = FakirErr.new(meth, args, err)
  Hal.set_filesystem(new_player)
  testr.assert_raises(err, &blk)

  Hal.set_filesystem(old_player)

end
