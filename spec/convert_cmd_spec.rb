# convert_cmd_spec.rb - specs for convert_cmd

require_relative 'spec_helper'

describe 'convert_cmd :cmd_yank' do
  let(:buf) { ScratchBuffer.new }
    subject { convert_cmd :cmd_yank  }

  specify { subject.must_equal :yank }
end
