# cov_report_spec.rb - specs for cov_report

require_relative 'spec_helper'

if $simplecov_loaded
  describe 'cov_report' do
    before { load_cov SRC_ROOT + '/coverage/coverage.json' }
    subject { cov_report }

    specify { subject; $buffer_ring.wont_be_empty }
  end

  describe 'cov_report with specific files, pcts' do
    before { load_cov SRC_ROOT + '/coverage/coverage.json' }
    subject { cov_report; $buffer_ring[0].to_s }

    specify { subject.wont_be_empty }
  end

end
