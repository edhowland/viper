# help_bindings_spec.rb - specs for help_bindings

require_relative 'spec_helper'

describe ':key_s' do
  let(:bind) { help_bindings }
  subject { bind[:key_s] }

  specify { subject.must_equal 's' }
end

describe ':key_5' do
  let(:bind) { help_bindings }
  subject { bind[:key_5] }

  specify { subject.must_equal '5' }
end

describe ':key_G' do
  let(:bind) { help_bindings }
  subject { bind[:key_G] }

  specify { subject.must_equal 'G' }
end

# puction, other chars

describe ':space' do
  let(:bind) {punctuation_help} 
  subject { bind[:space] }

  specify { subject.must_equal 'space' }
end

describe ':return' do
  let(:bind) {punctuation_help} 
  subject { bind[:return] }

  specify { subject.must_equal 'return' }
end

describe '#' do
  let(:bind) { help_bindings }
  subject { bind[:number] }

  specify { subject.must_equal 'number' }
end

describe ':ctrl_z' do
  let(:bind) { help_bindings }
  subject { bind[:ctrl_z] }

  specify { subject.must_equal 'control z' }
end
