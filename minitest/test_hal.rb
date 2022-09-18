# hal_test.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'

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
  def  test_physical_chdir_works
    home_dir do
      Hal.chdir '/'
      assert_eq Dir.pwd, '/'
    end
  end
  def test_chdir_non_existant_physical_raises_no_such_file_or_dir
    assert_raises Errno::ENOENT do 
      Hal.chdir '/xxtt/zzz', @vm.fs[:pwd]
    end 
  end
  def test_realpathequals_here
    home_dir do
      assert_eq(Hal.realpath('.'), ENV['HOME'])
    end
  end
  def test_rm
    Hal.touch '/v/xxx'
    assert Hal.exist?( '/v/xxx')
    Hal.rm '/v/xxx'
    assert_false Hal.exist?('/v/xxx')
  end

  def test_rm_raises_err_w_no_such_file_physical
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
end

# eed to test all the following methods
    #def [] path
    #def pwd
    #def relative? path
    #def chdir path, current_pwd
    #def virtual? path
    #def mkdir_p path
    #def open path, mode
    #def directory? path
    #def touch path
    #def basename path
    #def dirname path
    #def realpath path
    #def mv src, dest
    #def rm path
    #def exist? path
##
