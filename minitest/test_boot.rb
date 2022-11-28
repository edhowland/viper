# test_boot.rb: tests for the boot of VirtualMachine setup. E.g. boot_helper

require_relative 'test_helper'


class TestBoot < Minitest::Test
  def setup
    @vm = boot_etc
  end
  def test_boot_is_ok
    assert_is @vm, VirtualMachine
  end
  def test_cat_is_installed
    assert veval('type cat', vm: @vm)
  end
  def test_ins_is_installed
    assert veval('type ins', vm: @vm)
  end
end