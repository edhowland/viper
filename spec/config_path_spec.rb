# config_path_spec.rb - specs for config_path

require_relative 'spec_helper'

describe 'config_path finds full path' do
  subject { config_path }

  specify { subject.must_equal '/home/vagrant/src/viper/config/' }
end
