# assignment_list_spec.rb - specs for assignment_list

require_relative 'spec_helper'


describe AssignmentList do
  let(:fs) { FrameStack.new }
  let(:a1) { Assignment.new :a1, StringLiteral.new('a1') }
  let(:b2) { Assignment.new :b2, StringLiteral.new('b2') }
  let(:c3) { Assignment.new :c2, Deref.new(:a1) }
  let(:alist) { AssignmentList.new [a1, b2, c3 ] }
  before { alist.call frames:fs }
  subject { fs[:c3] }
  
  it 'should be a1' do
    subject.must_equal 'a1'
  end
end
