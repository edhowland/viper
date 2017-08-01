# viper_tests.rb - tests for  viper binary

require_relative 'test_helper'

class ViperTests < BaseSpike
  def set_up
    @vm = VirtualMachine.new
    @bscr = boot({}, @vm)
    @vscr = scripts({}, @vm)
  end
  def test_boot_has_one_file
    assert_eq @bscr.length, 1
  end
  def test_scripts_have_more_than_one_element_file
    assert (@vscr.length >= 1)
  end
  def test_scripts_starts_with_001
    assert_eq @vscr[0].pathmap('%f'), '001_editor.vsh'
  end
end