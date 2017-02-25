# statement_tests.rb - tests for Statement

require_relative 'test_helper'

class StatementTest < BaseSpike
  def set_up
    @vm = VirtualMachine.new
  end
  def test_stub_works
    stub m: 1 do |o|
      assert_eq o.m, 1
    end
  end
  def test_statement_new
    s = Statement.new [ 'nop' ]
  end
  def test_can_call_call
    stub ordinal: COMMAND, call: nil do |o|
      s = Statement.new [ o ]
    s.call env:@vm.ios, frames:@vm.fs
    end
  end
  def test_call_something_returns_command_name
    stub oordinal: COMMAND, call: 'cd' do |o|
      s = Statement.new [ o ]
         s.call env:@vm.ios, frames:@vm.fs
    end
  end
end