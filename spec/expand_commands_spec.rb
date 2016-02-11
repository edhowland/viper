# expand_commands_spec.rb - specs for expand_commands

require_relative 'spec_helper'

def clear_alias
  Viper::Session[:alias].clear unless Viper::Session[:alias].nil?
end


describe 'expands new -=> new' do
  before { clear_alias }
  subject { expand_commands 'new' }

    specify { subject.must_equal ['new'] }
end

describe 'expand_commands "foo; bar" => [foo, bar]' do
  before { clear_alias }
  subject { expand_commands 'foo; bar' }

  specify { subject.must_equal ['foo', 'bar'] }
end

describe 'expand_commands "foo ; bar"' do
  before { clear_alias }
  subject { expand_commands 'foo ; bar' }

  specify { subject.must_equal ['foo', 'bar'] }
end

describe 'expand_commands "foo;bar"' do
  before { clear_alias }
  subject { expand_commands 'foo;bar' }

  specify { subject.must_equal ['foo', 'bar'] }
end

describe 'expand_commands "foo ;bar"' do
  before { clear_alias }
  subject { expand_commands 'foo ;bar' }

  specify { subject.must_equal ['foo', 'bar'] }
end

describe 'expand_commands "xxx" => "zzz"' do
  before { clear_alias; save_alias 'xxx', 'zzz' }
  subject { expand_commands 'xxx' }

  specify { subject.must_equal ['zzz'] }
end

describe 'expand_commands "foo; baz" => ["foo", "zab"]' do
  before { clear_alias; save_alias 'baz', 'zab' }
  subject { expand_commands 'foo; baz' }

  specify { subject.must_equal ['foo', 'zab'] }
end

describe 'expand_commands "foo; bar" => ["oof", "rab"]' do
  before do
    clear_alias
    save_alias 'foo', 'oof'
    save_alias 'bar', 'rab'
end
  subject { expand_commands 'foo;bar' }

  specify { subject.must_equal ['oof', 'rab'] }
end
