# all_tests.rb - requires for tests

 require_relative 'spike_load'


# load tests herein

class MyTest < BaseSpike
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
end
