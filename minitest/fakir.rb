# class Fakir to mock a PhysicalLayer and function to wrap Hal.set_filesystem

class Fakir
  def initialize(meth, inp=[], out=nil)
    @meth = meth
    @inp = inp
    @out = out

    # record run statuses
    @result = {meth: false, inp: false}
  end
  def method_missing(name, *args)
    @result[:meth] = (@meth == name)
    @result[:inp] = (inp == args)

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

