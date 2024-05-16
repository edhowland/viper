# hal_test.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'
require_relative 'fakir'

class HalTest < MiniTest::Test
  def home_dir &blk
    old = Dir.pwd
    Dir.chdir ENV['HOME']
    yield
    Dir.chdir old
  end
  def setup
    @orig_dir = File.dirname(File.expand_path(__FILE__))
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
    @oldpwd = @vm.fs[:pwd]
  end

  # can we inject our mocked filesystem?
  def test_can_inject_mocked_filesystem
    Hal.set_filesystem(PhysicalLayer)
  end
    def runit string, vm
    block = Visher.parse! string
    vm.call block
  end
  def tear_down
    Dir.chdir File.dirname(File.expand_path(__FILE__))
    #Hal.chdir @oldpwd, @vm.fs[:pwd]
  end
  def test_mkdir_ok
    Hal.mkdir_p '/v/a/b'
    assert Hal.exist?('/v/a/b')
  end
  def test_chdir_ok
    Hal.mkdir_p '/v/a/b'
    Hal.chdir '/v/a/b'
    assert_eq Hal.pwd, '/v/a/b'
  end
  def test_chdir_raises_ioerror_if_not_directory
    Hal.touch '/v/foo'
    assert_raises Errno::ENOTDIR do
      Hal.chdir '/v/foo'
    end
    
  end
  def test_chdir_non_existant_path_raises_no_file_or_dir
        Hal.mkdir_p '/v/a/b'
            assert_raises Errno::ENOENT do 
      Hal.chdir '/v/a/c', @vm.fs[:pwd]
    end
  end
  def _test_physical_chdir_works
    run_safe(self, :chdir,['/'], nil) do 
      Hal.chdir '/'
    end
  end
  def _test_chdir_non_existant_physical_raises_no_such_file_or_dir
    assert_raises Errno::ENOENT do 
      Hal.chdir '/xxtt/zzz', @vm.fs[:pwd]
    end 
  end
  def _test_realpathequals_here
    Hal.chdir @orig_dir
    run_safe(self, :realpath, ['.'], @orig_dir) do
      assert_eq(Hal.realpath('.'), @orig_dir)
    end
  end
  def test_rm
    Hal.touch '/v/xxx'
    assert Hal.exist?( '/v/xxx')
    Hal.rm '/v/xxx'
    assert_false Hal.exist?('/v/xxx')
  end

  def _test_rm_raises_err_w_no_such_file_physical
    assert_raises Errno::ENOENT do 
      Hal.rm 'xyzzy'
    end
  end
  def test_rm_raises_no_such_file_e_virtual
    assert_raises Errno::ENOENT do 
      Hal.rm '/v/xxyyz'
    end

  end
  def test_cp_virtual_file
    Hal.chdir '/v'
    Hal.touch 'x'
    Hal.cp 'x', 'y'
    assert Hal.exist?('y'), 'Expected /v/y to be a copy of x'
  end
  def test_mv
    Hal.touch '/v/zzz'
    Hal.mv '/v/zzz', '/v/nnn'
    assert Hal.exist?('/v/nnn')
    assert_false Hal.exist?('/v/zzz')
  end
  def test_respond_to_mv
    assert Hal.respond_to?(:mv)
  end
  def test_respond_to_relative
    assert Hal.respond_to?(:relative?)
  end
  def test_respond_to_non_existant_method
    assert_false Hal.respond_to?(:xx)
  end
  def test_non_existant_method_call_raises_no_method_error
    assert_raises NoMethodError do
      Hal.xx
    end
  end
  def test_in_virtual_is_true_when_in_v
    Hal.chdir('/v')
    assert $in_virtual
  end
  def test_in_virtual_false_when_in_physical
    Hal.chdir(@orig_dir)
    assert_false $in_virtual
  end
  # check that ::ArgumentError raised for dispatched methods with wrong number of args in method_missing
  def test_argument_error_raised_when_wrong_arg_count_mismatch_of_dispatched
    assert_raises ::ArgumentError do
      Hal.exist?
    end
  end
  def test_argument_error_raised_when_in_virtual_and_arity_mismatch
    Hal.chdir('/v')
    assert_raises ::ArgumentError do
      Hal.exist?
    end
  end
  def test_argument_error_raised_when_in_physical_and_arity_mismatch
    Hal.chdir(@orig_dir)

    katch(self, :exist?, [], ::ArgumentError) do
      Hal.exist?
    end
  end
  def test_raises_argument_error__when_arg_is_nil
    assert_raises ::ArgumentError do
      Hal.exist? nil
    end
  end
  
  def test_fakir_can_run_hal_pwd
    Hal.chdir @orig_dir
    run_safe(self, :pwd, [], '/v/foo') do
      Hal.pwd
    end
  end

  def test_fakir_can_runbasename_w_fullpath
    Hal.chdir @orig_dir
    run_safe self, :[], ['.'], 'foo' do
      Hal['.']
    end
  end
end
