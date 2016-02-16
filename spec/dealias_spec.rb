# dealias_spec.rb - specs for dealias

require_relative 'spec_helper'

def clear
  Viper::Session[:alias] = {} 
end

describe 'no alias set' do
  before { clear }
  let(:sexp) { parse!('com') }
  subject { dealias sexp[0] }

  specify { subject.must_equal [[:com, []]] }
end

describe 'com aliased to moc' do
  before { clear; save_alias :com, 'moc' }
  let(:sexp) { parse! 'com' }
  subject { dealias sexp[0] }

  specify { subject.must_equal [[:moc, []]] }
end

describe 'block shows command passed if alias found' do
  before { clear; save_alias :com, 'xxx'; @found = nil }
let(:sexp) { parse! 'com' }
  subject { dealias(sexp[0]) {|w| @found = w }  }

  specify { subject; @found.must_equal :com }
end


describe 'self-referenced alias' do
  before { clear; save_alias :com, 'moc'; save_alias :moc, 'com' }
  let(:sexp) { parse! 'com' }
  subject { dealias(sexp[0], [:com]) }

  specify { subject.must_equal [[:com, []]] }
end

describe 'dealias_sexps' do
  before { clear }
  let(:sexp) { parse! 'com' }
  subject { dealias_sexps sexp }

  specify { subject.must_equal [[:com, []]] }
end

describe 'dealias_sexps - multiple' do
  before { clear }
  let(:sexp) { parse! 'com; yyy; zzz' }
  subject { dealias_sexps sexp }

  specify { subject.must_equal [[:com, []], [:yyy, []], [:zzz, []]] }
end

describe 'dealias_sexps - multiple with one alias' do
  before { clear; save_alias :com, 'moc' }
  let(:sexp) { parse! 'xxx ; com' }
  subject { dealias_sexps sexp }

  specify { subject.must_equal [[:xxx, []], [:moc, []]] }
end

describe 'dealias_sexps with seen before does not expand it' do
  before { clear; save_alias :com, 'moc' }
  let(:sexp) { parse! 'com' }
  subject { dealias_sexps sexp, [:com] }

  specify { subject.must_equal [[:com, []]] }
end

describe 'dealias_sexps self-referenced' do
  before { clear; save_alias :com, 'moc'; save_alias :moc, 'com' }
  let(:sexp) { parse! 'com' }
  subject { dealias_sexps sexp }

  specify { subject.must_equal [[:com, []]] }
end
