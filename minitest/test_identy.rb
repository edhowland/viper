# identy_tests.rb - tests for lib/api/identy.rb - each dependentclass
# should have identy method: to_s for String, to_a for Array, etc.
#  Misspelled intenttionally.

require_relative 'test_helper'

class IdentityTests < MiniTest::Test
  def test_string_returns_to_s_for_identy
    s = String.new
    assert_equal s.identy, :to_s
  end
  def test_hash_returns_to_h_for_identymethod
    h = Hash.new
    assert_equal h.identy, :to_h
  end
  def test_array_returns_to_a_for_identy
    a = Array.new
    assert_equal a.identy, :to_a
  end
  def test_string_io_returns_string_for_identy
    s = StringIO.new
    assert_equal s.identy, :string
  end
end

