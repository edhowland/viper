# string_buffer_spec.rb - specs for string_buffer

require_relative 'spec_helper'

describe 'initialize' do
  subject { StringBuffer.new 'abcdef' }

  specify { subject.must_be_instance_of StringBuffer }
  specify { subject.to_s.must_equal 'abcdef' }
end

describe 'shift' do
  let(:buf) { StringBuffer.new 'abcdef' }
  subject { buf.shift }

  specify { subject.must_equal 'a' }
end

describe 'after shift' do
  let(:buf) { StringBuffer.new 'abcdef' }
  subject { buf.shift }

  specify { subject;  buf.to_s.must_equal 'bcdef' }  
end

describe 'unshift' do
  let(:buf) { StringBuffer.new 'bcdef' }
  subject { buf.unshift 'a' }

  specify { subject; buf.to_s.must_equal 'abcdef' }
end

describe 'push' do
  let(:buf) { StringBuffer.new 'abcde' }
  subject { buf.push'f' }

  specify { subject; buf.to_s.must_equal 'abcdef' }
end

describe 'pop' do
  let(:buf) { StringBuffer.new 'abcdef' }
  subject { buf.pop }

  specify { subject.must_equal 'f' }
end
  
describe 'after pop' do
  let(:buf) { StringBuffer.new 'abcdef' }
  subject { buf.pop }

  specify { subject; buf.to_s.must_equal 'abcde' }
end

describe 'empty' do
  let(:buf) { StringBuffer.new '' }
  subject { buf.empty? }

  specify { subject.must_equal true }
end

describe '[]' do
  let(:buf) { StringBuffer.new 'abcdef' }
  
  specify { buf[0].must_equal 'a' }
  specify { buf[2].must_equal 'c' }
  specify { buf[-1].must_equal 'f' }
end

describe 'shift past front should raise exception' do
  let(:buf) { StringBuffer.new 'h' }
  before { buf.shift }
  subject { buf.shift }

  specify { ->() { subject }.must_raise BufferExceeded }
end

describe 'pop empty buffer raises BufferExceeded' do
  let(:buf) { StringBuffer.new '' }
  subject { buf.pop }

  specify { ->() { subject }.must_raise BufferExceeded }
end

describe 'copy range' do
  let(:buf) { StringBuffer.new('0123456789ABCDEF') }
  subject { buf.copy(10) }
  specify { subject.must_equal '0123456789' }
end

describe 'copy negative' do
  let(:buf) { StringBuffer.new '012345ABCDE' }
  subject { buf.copy(-5) }

  specify { subject.must_equal 'ABCDE' }
end

describe 'cut:fwd' do
  let(:buf) { StringBuffer.new '01234ABCDE' }
  subject { buf.cut 5}

  specify { subject.must_equal '01234' }
  specify { subject; buf.to_s.must_equal 'ABCDE' }
#  specify {buf.to_s.must_equal '012345CDE'  }
end


describe 'cut: back' do
  let(:buf) { StringBuffer.new '01234ABCDE'}
  subject { buf.cut -5 }

 specify { subject.must_equal 'ABCDE'; buf.to_s.must_equal '01234' }
end
