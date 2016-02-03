# lint_spec.rb - specs for lint

require_relative 'spec_helper'

describe 'lint' do
  let(:buf) { Buffer.new "line\n  line\n    line\n  line\nline\n" }
  subject { lint buf }

  specify { subject }
end

describe 'lint fail all passes' do
  let(:buf) { Buffer.new "line\n line\n  line\n      line\n\n\n\n" }
  subject { lint buf }

  specify { subject }
end
