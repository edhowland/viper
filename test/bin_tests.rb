# bin_tests.rb - tests for bin/* commands

require_relative 'test_helper'


class BinTests < BaseSpike
    def set_up
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
  end
  def test_stat_examine_reports_directory
    cmd = Stat.new
    str = cmd.examine Hal, :directory?, '/v/bin'
    assert_eq str, 'directory? true'
  end
  def test_stat_examine_directory_false
        cmd = Stat.new
    str = cmd.examine Hal, :directory?, '/v/xxx'
    assert_eq str, 'directory? false'
  end
  def test_examine_virtual_dir
    cmd = Stat.new
    str = cmd.examine Hal, :virtual?, '/v/bin'
    assert_eq str, 'virtual? true'
  end
  def test_examine_virtual_false
    cmd = Stat.new
    str = cmd.examine Hal, :virtual?, '/dev/null'
    assert_eq str, 'virtual? false'
  end
  # ls tests
  def test_ls_dir_star_w_directory
    cmd = Ls.new
    assert_eq cmd.dir_star('/v/bin'), '/v/bin/*'
  end
  def test_dir_star_w_file
    cmd = Ls.new
    assert_eq cmd.dir_star('xx'), 'xx'
  end
end