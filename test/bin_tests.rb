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
  def test_capture_one_block
    cmd = Capture.new
    result = cmd.call env: @vm.ios, frames: @vm.fs
    assert_false result
  end
  def test_capture_works_w_one_lambda
    cmd = Capture.new
    block = Block.new [ True.new ]
    result = cmd.call block, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_2_blocks
    cmd = Capture.new
        block = Block.new [ True.new ]
        handler = Block.new [ ]
    result = cmd.call block, handler, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_3_blocks
        cmd = Capture.new
        block = Block.new [ True.new ]
        handler = Block.new [ ]
           fin = Block.new [ False.new ]
    result = cmd.call block, handler, fin, env: @vm.ios, frames: @vm.fs
    assert result
  end
  def test_capture_w_exception
    cmd = Capture.new
    block = Block.new [ Raise.new ]
    handler = Visher.parse! 'result=ok; global result'
    result = cmd.call block, handler, env: @vm.ios, frames: @vm.fs
    assert_false result
    assert_eq @vm.fs[:result], 'ok'
  end
end
