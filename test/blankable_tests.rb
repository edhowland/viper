# blankable_tests.rb - tests for module Blankable

require_relative 'test_helper'

class BlankableTests < BaseSpike
  def mk_obj &blk
    obj = yield
    obj.extend Blankable
    obj
  end
  def test_true_if_nil?
    obj = nil
    obj.extend Blankable
    assert obj.blank?
  end
  def test_true_if_empty
    obj = ''
    obj.extend Blankable
    assert obj.blank?
  end
  def test_true_if_only_contains_white_space
    obj = '     '
    obj.extend Blankable
    assert obj.blank?
  end
  def test_false_if_not_empty
    obj = mk_obj { [0] }
    assert_false obj.blank?
  end
end