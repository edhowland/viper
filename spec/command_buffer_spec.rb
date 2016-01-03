# command_buffer_spec.rb - specs for command_buffer

require_relative 'spec_helper'

describe '<<' do
  let(:buf) { CommandBuffer.new }
  subject { buf << [:ins, 'i'] }

  specify {  subject; buf.back.must_equal [:ins, 'i'] }

end
