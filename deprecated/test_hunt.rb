# hunt_test.rb - tests for  command hunt - searches class and rotates array

require_relative 'test_helper'


class HuntTest < MiniTest::Test
  def setup
    @vm = boot_etc
      src = 'mkarray /v/xx; echo -n hello | push /v/xx; echo -n world | push /v/xx; echo -n sailor | push /v/xx'
    block = Visher.parse!(src)
    @vm.call block
    @cmd = Hunt.new
  end
  def test_actually_rotates_object
    @cmd.call('/v/xx', 'String', env:@vm.ios, frames:@vm.fs)
    arr = Hal.open('/v/xx', 'r').io
    assert_is arr, Array
    assert_eq arr.first, 'world'
  end
  def test_hunt_reverse_actually_reverses_array
    #skip 'until refactor'
    @cmd.call '-r', '/v/xx', 'String', env: @vm.ios, frames: @vm.fs
    array = Hal.open('/v/xx', 'r').io
    assert_eq array.first.to_s, 'sailor'
  end
  def test_back_works
      array = Hal.open('/v/xx', 'r').io

    @cmd.back array, String
    assert_eq array.first.to_s, 'sailor'
  end

  # Since we removed Markdown parsing, this test not longer applies
=begin
  def test_dash_t_hunts_to_top
    array = Hal.open('/v/xx', 'r').io
    array.clear
    bh = BlockHead.new(1, 'First')
    bh.extend Toppable
    bh.top = true
    array.unshift bh
    array.rotate!(-2)
    @cmd.call '-t', '/v/xx', 'String', env: @vm.ios, frames: @vm.fs
    assert_eq array.first.to_s, 'Heading 1 First'
  end
=end
end
