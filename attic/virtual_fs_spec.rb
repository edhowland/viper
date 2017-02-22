# virtual_fs_spec.rb - specs for virtual_fs

require_relative 'spec_helper'

describe Viper::VFS do
  describe 'path_to_key' do
    before { Viper::VFS["buf"] = { "first" => 99 } }
    subject { Viper::VFS.path_to_value '/buf/first' }
    it 'should be 99' do
      subject.must_equal 99
    end
  end
  describe 'directory? .' do
    let(:path) { '.' }
    subject { Viper::VFS.directory?(path) }
    it 'should be true' do
      subject.must_equal true
    end
  end
  describe 'directory? spec_helper.rb' do
    let(:path) { 'spec_helper.rb' }
    subject { Viper::VFS.directory?(path) }

    it 'should be false' do
      subject.must_equal false
    end
  end
  describe 'resolve_path .' do
    let(:path) { '.' }
    subject { Viper::VFS.resolve_path path }
    it 'should be [ ... ] list of files' do
      subject.must_be_instance_of Array
      subject.wont_be_empty
    end
  end
  describe 'resolve_path spec_helper.rb' do
    let(:path) { 'spec_helper.rb' }
    subject { Viper::VFS.resolve_path path }
    it 'should be a string' do
      subject.must_equal 'spec_helper.rb'
    end
  end
  describe 'resolve_path non-existant path' do
    let(:path) { 'xyzzy' }
    subject { Viper::VFS.resolve_path path }
    it 'should raise non-existant path' do
      ->{ subject }.must_raise RuntimeError
    end
  end
  describe 'virtual? /buf' do
    let(:path) { '/buf' }
    before { Viper::VFS['buf'] = { '0' => 99 } }
    subject { Viper::VFS.virtual? path }
    it 'should be true' do
      subject.must_equal true
    end
  end
  describe 'virtual? /tmp' do
    let(:path) { '/tmp' }
    before { Viper::VFS['buf'] = { '0' => 99 } }
    subject { Viper::VFS.virtual? path }
    it 'should be false' do
      subject.must_equal false
    end
    it 'should be true for directory?' do
      Viper::VFS.directory?(path).must_equal true
    end
  end
  describe 'path_to_parent' do
    let(:path) { '/buf/xyzzy' }
    subject { Viper::VFS.path_to_parent path }
    it 'should be a Hash' do
      subject.must_be_instance_of Hash
    end
  end
  describe 'mknode /buf/xyzzy' do
    let(:path) { '/buf/xyzzy' }
    subject { Viper::VFS.mknode path; Viper::VFS.path_to_value path }
    it 'should be a Buffer' do
      subject.must_be_instance_of Buffer
    end
  end
end
