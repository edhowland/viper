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
