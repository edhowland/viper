require_relative '../spike_load'

class NoSkip < BaseSpike
  def test1
    #
  end
  def test_fail
    assert false
  end
  def test_error
    raise RuntimeError.new 'bad juju'
  end
end
