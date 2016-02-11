# expand_alias_spec.rb - specs for expand_alias

require_relative 'spec_helper'

def clear_alias
  Viper::Session[:alias].clear unless Viper::Session[:alias].nil?
end

describe 'expand_alias - new returns new' do
  before { Viper::Session[:alias].clear unless Viper::Session[:alias].nil?  }
  subject { expand_alias 'new' }

  specify { subject.must_equal 'new' }
end

describe 'expand_alias newsnip into new snip' do
  before { save_alias 'newsnip', 'new', 'snip' }
  subject { expand_alias 'newsnip' }

  specify { subject.must_equal 'new snip' }
end

describe 'expand_alias with no alias' do
  before { save_alias 'newsnip', 'new', 'snip' }
  subject { expand_alias 'xxx' }

  specify { subject.must_equal 'xxx' }
end

describe 'expand_aliais with args' do
  before { clear_alias }
  subject { expand_alias 'excite me some more' }

  specify { subject.must_equal 'excite me some more' }
end

describe 'expand alias with alias and args' do
  before { clear_alias; save_alias 'foo', 'baz' }
  subject { expand_alias 'foo arg parm' }

  specify { subject.must_equal 'baz arg parm'}
end