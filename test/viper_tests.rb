# viper_tests.rb - tests for  viper binary


require_relative 'test_helper'


class ViperTests < BaseSpike
  def test_ok
    @vm = VirtualMachine.new
    bscr = boot({}, @vm)
    vscr = scripts({}, @vm)
  end
end