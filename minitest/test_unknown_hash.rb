# unknown_hash.rb - tests for 

require_relative 'test_helper'

class UnknownHashTests < MiniTest::Test
  def setup
    @u = UnknownHash.new
  end
  def test_returns_unknown
    assert_nil @u[:thing]
  end
  def test_still_returns_unknown
    assert_nil @u[[200, 11, 44]]
  end
end