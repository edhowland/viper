# lint_pass2_spec.rb - specs for lint_pass2

require_relative 'spec_helper'

describe 'lint_pass2' do
  let(:buf) { Buffer.new "line\n  line\n      line\nline\n" }
  subject { lint_pass2 buf }

  specify { subject.wont_be_empty }



end

describe 'lint_pass2 OK' do
  let(:buf) { Buffer.new "line\nline\n  line\n    line\n  line\nline\n" }
  subject { lint_pass2 buf }

  specify { subject.must_be_empty }



end
