# deref_spec.rb - specs for deref

require_relative 'spec_helper'
describe Deref do
  describe 'when given no starting hash' do
    let(:drf) { Deref.new :key }
    let(:fs) { FrameStack.new }
    subject { drf.call frames:fs }
    it 'should be empty string' do
      subject.must_equal ''
    end
  end
  describe 'when given a starting hash with :key' do
    let(:drf) { Deref.new :key }
    let(:fs) { FrameStack.new(frames:[{:key => 'dog'}]) }
    subject { drf.call frames:fs }
    it 'should be dog' do
      subject.must_equal 'dog'
    end
  end
end
