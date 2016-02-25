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

describe 'command proc :alias' do
  let(:buf) { Buffer.new '' }
  before { Viper::Session[:alias] = {} }
  let(:bind) { command_bindings }
  subject { prc = bind[:alias]; prc.call(buf, 'ns', 'new'); Viper::Session[:alias][:ns] }

  specify { subject.must_equal 'new' }
end

describe 'report alias' do
  let(:buf) { Buffer.new '' }
  before { clear; save_alias :zoolander, 'new' }
  let(:bind) { command_bindings }
  subject { prc = bind[:alias]; prc.call buf, 'zoolander' }

  specify { subject.must_equal 'new' }
end

describe 'command unalias' do
  let(:buf) { Buffer.new '' }
  before { clear; save_alias :ragnarok, 'thor' }
  let(:bind) { command_bindings }
  subject { prc = bind[:unalias]; prc.call buf, 'ragnarok'; report_alias :ragnarok }

  specify { subject.must_equal nil }
end
