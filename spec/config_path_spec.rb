# config_path_spec.rb - specs for config_path

require_relative 'spec_helper'

def my_path
  File.dirname(File.expand_path(__FILE__))
end

def make_path(dir)
  File.expand_path(my_path + '/' + dir) + '/'
end

describe 'config_path finds full path' do
  subject { config_path }

  specify { subject.must_equal make_path('../config') }
end
