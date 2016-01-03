# recordable_spec.rb - specs for recordable

require_relative 'spec_helper'

class MyBuffer < Buffer
  include Recordable

  attr_reader :commands
end

describe 'invert :del' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.ins('i'); buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:del, 'i'] }

end

describe 'invert :del' do
  let(:buf) { MyBuffer.new 'd' }
  subject {  buf.fwd; buf.del; buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:ins, 'd'] }

end

describe 'invert :fwd' do
  let(:buf) { MyBuffer.new 'now' }
  subject {  buf.fwd; buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:back, 1] }

end

describe 'invert :back' do
  let(:buf) { MyBuffer.new 'now'  }
  subject {  buf.fwd; buf.fwd; buf.back; buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:fwd, 1] }

end

describe 'invert :unk' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.invert([:unk, nil]) }

  specify {  subject.must_equal [nil, nil] }

end
