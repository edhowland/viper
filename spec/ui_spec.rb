# ui_spec.rb - specs for ui

require_relative 'spec_helper'

describe 'suppress_audio' do
  subject do
    suppress_audio { say 'hi' }
  end


  specify { subject }
end

describe 'display_help' do
  subject { help_buffer.to_s }

  specify { subject.wont_be_empty }
end
