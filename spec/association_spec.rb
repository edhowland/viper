# association_spec.rb - specs for association

require_relative 'spec_helper'

describe 'ext_regex=' do
    let(:ass) { Association.new }
    subject { ass.ext_regex=(%r{r.?}, :r2) }

  specify { subject }
end
