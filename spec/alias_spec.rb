# alias_spec.rb - specs for alias

require_relative 'spec_helper'

def clear
  Viper::Session[:alias] = {}
end


describe 'save_alias' do
  before { clear }
  subject { save_alias :foo, 'bar'; Viper::Session[:alias][:foo] }

  specify { subject.must_equal 'bar' }
end

describe 'report_alias' do
  before { clear; save_alias :foo, 'bar' }
  subject { report_alias :foo }

  specify { subject.must_equal 'bar' }
end

describe 'delete_alias foo' do
  before { clear; save_alias :foo, 'bar' }
  subject { delete_alias :foo; report_alias :foo }

  specify { subject.must_be_nil }
end
