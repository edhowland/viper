# hunt_test.rb - tests for  command hunt - searches class and rotates array

require_relative 'test_helper'


class HuntTest < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;     mkdir /v/bin;     install; mkarray /v/xx;' + 
      'echo -n hello | push /v/xx; echo -n world | push /v/xx; echo -n sailor | push /v/xx'
    @vm.call block
    @cmd = Hunt.new
  end
  def test_actually_rotates_object
    @cmd.call('/v/xx', 'String', env:@vm.ios, frames:@vm.fs)
    arr = Hal.open('/v/xx', 'r').io
    assert_is arr, Array
    assert_eq arr.first, 'world'
  end
end