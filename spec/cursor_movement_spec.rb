# cursor_movement_spec.rb - specs for cursor_movement

require_relative 'spec_helper'

describe 'up on empty buffer' do
  let(:buf) { Buffer.new '' }
  subject { buf.up }

  specify { ->() { subject}.must_raise BufferExceeded; buf.col.must_equal 0}
end
