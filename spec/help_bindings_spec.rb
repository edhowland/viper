# help_bindings_spec.rb - specs for help_bindings

require_relative 'spec_helper'

describe ':key_s' do
  let(:bind) { help_bindings }
  subject { bind[:key_s] }

  specify { subject.must_equal 's' }
end
