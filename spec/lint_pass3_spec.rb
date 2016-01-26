# lint_pass3_spec.rb - specs for lint_pass3

require_relative 'spec_helper'

describe 'lint_pass3 success' do
  let(:buf) { Buffer.new "line\n\nline\n\nline\n" }
  subject { lint_pass3 buf }

  specify { subject.must_be_empty }
end

describe 'lint_pass3 fail' do
  let(:buf) { Buffer.new "lint\n\n\n\nline\n\nline\n" }
  subject { lint_pass3 buf }

  specify { subject.wont_be_empty }
end

describe 'lint_pass3 success for just one blank line' do
  let(:buf) { Buffer.new "line\n\n" }
  subject { lint_pass3 buf }

  specify { subject.must_be_empty }
end
