
require_relative 'test_helper'
require_relative 'fakir'

class TestFakir < MiniTest::Test
  def test_ok
    run_safe(self, :pwd) do
      assert true
    end


  end
  def test_preserves_old_filesystem
    clip = Hal.get_filesystem
    run_safe(self, :pwd) { }
    assert_equals clip, Hal.get_filesystem
        end
end
