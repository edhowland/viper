# all_tests.rb - requires for tests

 require_relative 'lib/spike_load'

# load tests herein

class MyTest < BaseSpike
  def set_upmethod
    
  end
  def test_pass
    #
  end
  def test_fail
    assert false
  end
  def test_error
    raise RuntimeError.new 'bad juju'
  end
  def test_skip
    skip 'not now'
  end
  def tear_down
    
  end
end


class OtherTests < BaseSpike
  def test_ok
    #
  end
  def test_ok2
    #
  end
  def test_ok3
    #
  end
end