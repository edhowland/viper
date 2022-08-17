# ref_state_tests.rb - tests for refactored Statement class
# use _call instead of def call(...)

require_relative 'test_helper'

class RefStateTests < MiniTest::Test
  def parse string
    b = Visher.parse! string
    b.statement_list.first
  end
  def setup
    @vm = VirtualMachine.new
    block = Visher.parse! 'mount /v;mkdir /v/bin;install'
    @vm.call block
  end
  def test_exec
    s = parse 'exec { false }'
    result = s._call env: @vm.ios, frames: @vm.fs
    assert_false result
  end
end
