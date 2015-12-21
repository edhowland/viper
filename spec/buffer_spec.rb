# buffer_spec.rb - specs for buffer

require_relative 'spec_helper'
describe 'initialize' do
  subject { Buffer.new 'abcdef' }

  specify { subject.to_s.must_equal 'abcdef' }
end

describe 'ins' do
  let(:buf) { Buffer.new 'quick brown fox' }
  subject { buf.ins 'the ' }
  specify { subject; buf.to_s.must_equal 'the quick brown fox' }
end

describe 'del' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.del }

  specify { ->() { subject }.must_raise OperationNotPermitted }
end

describe 'fwd' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd }

  specify { subject; buf.to_s.must_equal 'abcdef' }
end

describe 'fwd then del' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd; buf.del }

  specify { subject; buf.to_s.must_equal 'bcdef' }
end
  
