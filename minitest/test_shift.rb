#  test_shift: class ShiftTest

require_relative 'test_helper'


class ShiftTest < MiniTest::Test
    def setup
    @orig_dir = File.dirname(File.expand_path(__FILE__))
    @errbuf = StringIO.new
    @outbuf = StringIO.new
    @inbuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.ios[:err] = @errbuf
    @vm.ios[:out] = @outbuf
    @vm.cd @orig_dir, env:@vm.ios, frames:@vm.fs

    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
  end
  def setup
    @orig_dir = File.dirname(File.expand_path(__FILE__))
    @errbuf = StringIO.new
    @outbuf = StringIO.new
    @inbuf = StringIO.new
    @vm = VirtualMachine.new
    @vm.ios[:err] = @errbuf
    @vm.ios[:out] = @outbuf
    @vm.cd @orig_dir, env:@vm.ios, frames:@vm.fs

    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vm.mkdir '/v/bin', env:@vm.ios, frames:@vm.fs
    @vm.install env:@vm.ios, frames:@vm.fs
  end
  def set_var var, val
    @vm.fs.first[var.to_sym] = val
  end
  def get_var var
    @vm.fs[var.to_sym]
  end
  def go command
    @vm.call(Visher.parse!(command))
  end
  def test_ok
    #
  end
  def test_shift_errors_onno_args
      go 'shift'

    puts @vm.ios[:err].string
    assert_false @vm.ios[:err].string.empty?
  end
  def test_shift_w_flag_s_works
    set_var :foo, [1,2,3]
    go 'shift -s foo j'
    assert_eq 1, get_var(:j)
  end
  def test_shift_can_grab_two_variables
    set_var :arr, [1,2,3]
    go 'shift -s arr j k'
    assert_eq 1, get_var(:j)
    assert_eq 2, get_var(:k)
  end
  def test_shift_3_last_is_empty_string
    set_var :f, [1,2]
    go 'shift -s f a b c'
    assert_eq 1, get_var(:a)
    assert_eq 2, get_var(:b)
    assert_eq '', get_var(:c)
  end
end
