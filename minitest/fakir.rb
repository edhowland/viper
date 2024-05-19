# class Fakir to mock a PhysicalLayer and function to wrap Hal.set_filesystem

# Actual layer preserving context
def with_layer(layer, &blk)
  old_layer = Hal.get_filesystem
  Hal.set_filesystem(layer)
  #puts "in with_layer(#{layer.class.name})"
  yield
  Hal.set_filesystem(old_layer)
end



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
  with_layer(Fakir.new(meth, inp, out), &blk)



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
  with_layer(FakirErr.new(meth, args, err)) do
    testr.assert_raises(err, &blk)
  end
end


# This test double mimics a stateful PhysicalLayer.chdir and pwd

class StatefulFakir
  def chdir(path)
    @dir = path
  end

    def pwd
    @dir
    end

end


# wrapper for stateful chdir tests must pass self, the dir to chdir, the current dir and a block
# The block is passed the current dir passed in prev_dir
def run_cd(path, prev_dir, &blk)
  with_layer(StatefulFakir.new) do
    blk.call(prev_dir)
  end
end
