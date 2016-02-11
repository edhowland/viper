# expand_alias_spec.rb - specs for expand_alias

require_relative 'spec_helper'

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
