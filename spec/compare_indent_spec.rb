# compare_indent_spec.rb - specs for compare_indent

require_relative 'spec_helper'

describe CompareIndent do
    let(:cmp) { CompareIndent.new }
  describe 'lt' do
    subject { cmp.lt 2, 6 }

    specify { subject.must_equal [2,6] }
end

  describe 'lt OK' do
    subject { cmp.lt 2,4 }

      specify { subject.must_equal nil }


end

  describe 'gt' do
    subject { cmp.gt 6, 2 }

      specify { subject.must_equal [6, 2] }


end
  describe 'gt OK' do
    subject { cmp.gt 6, 4 }

      specify { subject.must_equal nil }


end

end
