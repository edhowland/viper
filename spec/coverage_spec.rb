# coverage_spec.rb - specs for coverage

require_relative 'spec_helper'

describe 'load_coverage' do
  before { load_cov SRC_ROOT + '/coverage/coverage.json' }
  subject { Viper::Session[:coverage] }

  specify { subject.wont_be_empty }
end

describe 'cov w/o prior loaded coverage.json file' do
  let(:buf) { ScratchBuffer.new }
  before { Viper::Session.clear }
  subject { cov buf, SRC_ROOT + '/lib/association/association.rb' }

  specify { -> { subject }.must_raise CoverageJSONNotLoaded }
end

describe 'cov with prior loaded coverage.json' do
  before { load_cov SRC_ROOT + '/coverage/coverage.json' }
  let(:buf) { ScratchBuffer.new }
  subject { cov buf, SRC_ROOT + '/lib/associations/association.rb' }

  specify { subject }
end

describe 'cov with unknown file raises FileNotReportedInCoverage' do
  before { load_cov SRC_ROOT + '/coverage/coverage.json' }
  let(:buf) { ScratchBuffer.new }
  subject { cov buf, 'xxyyz.rb' }

  specify { -> { subject }.must_raise FileNotReportedInCoverage }
end
