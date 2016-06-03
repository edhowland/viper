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
end
