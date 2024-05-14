# class Fakir to mock a PhysicalLayer and function to wrap Hal.set_filesystem

class Fakir
  def verify!
    return true
  end
end

# Makes sure Hal filesystem @@p_layer is saved and preserved
def run_safe(&blk)
  old_player = Hal.get_filesystem
  new_player = Fakir.new

  Hal.set_filesystem(new_player)
  yield
  Hal.set_filesystem(old_player)
  new_player.verify!
end

