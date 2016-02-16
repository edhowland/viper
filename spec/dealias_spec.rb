# dealias_spec.rb - specs for dealias

require_relative 'spec_helper'

describe 'no alias set' do
  let(:sexp) { parse!('com') }
  subject { dealias sexp[0] }

  specify { subject.must_equal [[:com, []]] }
end
