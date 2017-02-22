# recordable_spec.rb - specs for recordable

require_relative 'spec_helper'

# MyBuffer Sample Buffer that is Recordable and exposes the commands arrary.
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
  let(:buf) { MyBuffer.new 'now' }
  subject {  buf.fwd; buf.fwd; buf.back; buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:fwd, 1] }

end

describe 'invert :unk' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.invert([:unk, nil]) }

  specify {  subject.must_equal [nil, nil] }

end

describe 'undo' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.ins 'Now is the'; buf.undo; buf.to_s }

  specify {  subject.must_equal '' }

end

describe 'undo complicated stuff' do
  let(:buf) { MyBuffer.new 'good times' }
  subject {  buf.fwd 4; buf.del 'good'; buf.undo; buf.undo; buf.at }

  specify {  subject.must_equal 'g'; buf.to_s.must_equal 'good times' }
end

describe 'redo' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.ins 'now is'; buf.undo; buf.redo; buf.to_s }

  specify {  subject.must_equal 'now is' }

end
