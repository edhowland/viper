# argument_list_spec.rb - specs for argument_list

require_relative 'spec_helper'

describe ArgumentList do
  describe 'when given an empty list' do
    let(:fs) { FrameStack.new }
    let(:al) { ArgumentList.new [] }
    subject { al.call frames:fs }
    it 'should be []' do
      subject.must_equal []
    end
    describe 'when given 2 Arguments, one with string interpolation' do
      let(:fs) { FrameStack.new }
      before { fs[:dog] =  'fido' }
      let(:a1) { Argument.new StringLiteral.new("a1") }
      let(:a2) { Argument.new StringLiteral.new("my dog is :{dog}") }
      let(:al) { ArgumentList.new [a1, a2] }
      it 'should be [a1, my dog is fido]' do
        subject.must_equal ['a1', 'my dog is fido']
      end
    end
  end
  describe 'when given a single deref argument' do
    let(:fs) { FrameStack.new }
    before { fs[:dog] = 'fido' }
    let(:arg) { Argument.new Deref.new(:dog) }
    let(:al) { ArgumentList.new [ arg ] }
    subject { al.call frames:fs }
    it 'should be [ fido ]' do
      subject.must_equal ['fido']
    end
  end
end
