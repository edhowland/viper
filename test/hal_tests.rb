# hal_test.rb - tests for Hal - chdir, virtual?, others

require_relative 'test_helper'

class HalTest < BaseSpike
  def home_dir &blk
    old = Dir.pwd
    Dir.chdir ENV['HOME']
    yield
    Dir.chdir old
  end
    def set_up
      @orig_dir = File.dirname(File.expand_path(__FILE__))
    @vm = VirtualMachine.new
    @vm.mount '/v', env:@vm.ios, frames:@vm.fs
    @vroot = @vm.fs[:vroot]
    @oldpwd = @vm.fs[:pwd]
  end
  def tear_down
    Dir.chdir File.dirname(File.expand_path(__FILE__))
    #Hal.chdir @oldpwd, @vm.fs[:pwd]
  end
  def test_mkdir_ok
    Hal.mkdir_p '/v/a/b'
  end
  def test_chdir_ok
    Hal.mkdir_p '/v/a/b'
    Hal.chdir '/v/a/b', @vm.fs[:pwd]
  end
  def test_chdir_non_existant_path_raises_no_file_or_dir
        Hal.mkdir_p '/v/a/b'
            assert_raises Errno::ENOENT do 
      Hal.chdir '/v/a/c', @vm.fs[:pwd]
    end
  end
  def test_physical_chdir_works
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
end
# need to test all the following methods
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
