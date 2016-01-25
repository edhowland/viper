# lint_pass1.rb_spec.rb - specs for lint_pass1.rb

require_relative 'spec_helper'

describe 'All even OK?' do
  let(:buf) { Buffer.new "lin\n  line\n    line\nline\n" }
  subject { lint_pass1 buf }

  specify { subject.must_be_empty }
end

describe 'some odd BAD' do
  let(:buf) { Buffer.new "line\n line\n  line\n   line\n      line\nline\n" }
  subject { lint_pass1 buf }

  specify { subject.wont_be_empty }
end
