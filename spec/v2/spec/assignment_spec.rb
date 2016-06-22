# assignment_spec.rb - specs for assignment

require_relative 'spec_helper'

describe Assignment do
  describe 'with symbol and StringLiteral' do
    let(:fs) { FrameStack.new }
    let(:ass) { Assignment.new(:key, StringLiteral.new("Some string")) }
    before { ass.call frames:fs }
    subject { fs[:key] }
    it 'should be {:key => "Some String"}' do
      subject.must_equal 'Some string'
    end
  end
  describe 'first assignment, second depends on first' do
    let(:fs) { FrameStack.new }
    before { a1 = Assignment.new :a1, StringLiteral.new('dog'); a1.call(frames:fs) }
    let(:drf) { Deref.new :a1 }
    let(:b2) { Assignment.new :b2, drf }
    subject { b2.call(frames:fs); fs[:b2] }
    it 'should be dog' do
      subject.must_equal 'dog'
    end
  end
end
