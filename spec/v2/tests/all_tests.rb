# all_tests.rb - requires for tests

 require_relative 'lib/spike_load'

# load tests herein

class MyTest < BaseSpike
  def set_upmethod
    @thing = -99
  end
  def test_pass
    assert_equals @thing, -99
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
  def test_thing_is_nil
    assert_nil @thing
  end
  def tear_down
    @thing = nil
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