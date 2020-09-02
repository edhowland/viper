# red_test.rb - class Red - one failing test

 require_relative '../spike_load'

class RedTest < BaseSpike
  def test_fail_redmethod
    assert false
  end
end