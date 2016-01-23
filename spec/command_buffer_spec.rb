# command_buffer_spec.rb - specs for command_buffer

require_relative 'spec_helper'

describe '<<' do
  let(:buf) { CommandBuffer.new }
  subject { buf << [:ins, 'i'] }

  specify {  subject; buf.back.must_equal [:ins, 'i'] }
end

describe 'fwd after back' do
  let(:buf) { CommandBuffer.new }
  subject {  buf << [:ins, 'i']; buf << [:del]; buf.back; buf.fwd} 

  specify { subject.must_equal [:del]  }
end

describe 'at_start?' do
  let(:buf) {CommandBuffer.new }
  subject { buf.at_start? }

  specify { subject.must_equal true }

end

describe 'at_end?' do
  let(:buf) {CommandBuffer.new }
  subject { buf.at_end? }

  specify { subject.must_equal true }

end

describe 'after << at_start? false' do
  let(:buf) {CommandBuffer.new }
  subject { buf << [:fwd, 1]; buf.at_start? }

  specify { subject.must_equal false }

end

describe 'after <<, at_end? true' do
  let(:buf) {CommandBuffer.new }
  subject { buf << [:fwd, 1]; buf.at_end? }

  specify { subject.must_equal true }
end

describe 'after <<, back' do
  let(:buf) {CommandBuffer.new }
  subject { buf << [:fwd, 1]; buf.back; buf.at_end? }

  specify { subject.must_equal false }

end

describe 'after <<, back, fwd: at_start? false' do
  let(:buf) {CommandBuffer.new }
  subject { buf << [:fwd, 1]; buf.back; buf.fwd; buf.at_start? }

  specify { subject.must_equal false }

end
