
require_relative 'test_helper'
require_relative 'fakir'

class TestFakir < MiniTest::Test
  def test_ok
    run_safe(self, :pwd) do
      assert true
    end


  end
end
