# make_bindings_spec.rb - specs for make_bindings

require_relative 'spec_helper'

describe 'make_bindings returns a key inserter proc for letters' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_p] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal 'p' }
end

describe 'inserter for caps' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_A] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal 'A' }
end

describe 'inserter 0' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:key_0] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal '0' }
end

describe 'special chars :space' do
  let(:buf) { Buffer.new '' }
  let(:bind) { make_bindings }
  let(:prc) { bind[:space] }
  subject { prc.call(buf); buf.to_s }

  specify { subject.must_equal ' ' }
end
