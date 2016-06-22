# argument_spec.rb - specs for argument

require_relative 'spec_helper'

describe Argument do
  describe 'when given a QuotedString' do
    let(:fs) { FrameStack.new }
    let(:arg) { Argument.new QuotedString.new('dog') }
    subject { arg.call frames:fs }
    it 'should be dog' do
      subject.must_equal 'dog'
    end
  end
  describe 'when given a StringLiteral' do
    let(:fs) { FrameStack.new }
    let(:arg) { Argument.new(StringLiteral.new('cat')) }
    subject { arg.call frames:fs }
    it 'should be cat' do
      subject.must_equal 'cat'
    end
  end
  describe 'when dereferencing a non-existant thing' do
    let(:fs) { FrameStack.new }
    let(:arg) { Argument.new(Deref.new(:dog)) }
    subject { arg.call frames:fs }
    it 'should be empty string' do
      subject.must_equal ''
    end
  end
  describe 'when given a pre-existing thing in frames' do
    let(:fs) { FrameStack.new }
    let(:ass) { Assignment.new :pet, StringLiteral.new('fido') }
    before { ass.call frames:fs }
    let(:arg) { Argument.new Deref.new(:pet) }
    subject { arg.call frames:fs }
    it 'should be fido' do
      subject.must_equal 'fido'
    end
  end
end
