# buffer_spec.rb - specs for buffer

require_relative 'spec_helper'
describe 'initialize' do
  subject { Buffer.new 'abcdef' }

  specify { subject.to_s.must_equal 'abcdef' }
end

describe 'ins' do
  let(:buf) { Buffer.new 'quick brown fox' }
  subject { buf.ins 'the ' }
  specify { subject; buf.to_s.must_equal 'the quick brown fox' }
end

describe 'del' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.del }

  specify { ->() { subject }.must_raise BufferExceeded }
end

describe 'fwd' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd }

  specify { subject; buf.to_s.must_equal 'abcdef' }
end

describe 'fwd then del' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd; buf.del }

  specify { subject; buf.to_s.must_equal 'bcdef' }
end
  

describe 'fwd then ins' do
  let(:buf) { Buffer.new 'the brown fox' }
  subject { buf.fwd; buf.fwd; buf.fwd; buf.fwd; buf.ins 'quick ' }

  specify { subject; buf.to_s.must_equal 'the quick brown fox' }
end

describe 'back' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd; buf.fwd; buf.back;  buf.ins '1' }

  specify { subject; buf.to_s.must_equal 'a1bcdef' }
end

describe 'at' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { buf.fwd; buf.fwd; buf.at }

  specify { subject.must_equal 'c' }
end


describe 'copy' do
  let(:buf) { Buffer.new '01234ABCDE' }
  subject { buf.fwd(5); buf.set_mark; buf.back(2);  buf.copy }

  specify {  subject.must_equal '34' }
end

describe 'set mark and copy (reverses direction)' do
  let(:buf) {Buffer.new '01234ABCDEF' }
  subject { buf.fwd 5; buf.set_mark; buf.fwd; ; buf.fwd; buf.copy }

  specify { subject.must_equal 'AB' }

end

describe 'cut fwd' do
  let(:buf) {Buffer.new '01234ABCDE' }
  subject { buf.fwd 3; buf.set_mark;  buf.fwd; buf.fwd; buf.cut }

  specify { subject.must_equal '34'; buf.to_s.must_equal '012ABCDE' }

end

describe 'cut back' do
  let(:buf) {Buffer.new '01234ABCDE' }
  subject { buf.fwd 5; buf.set_mark;  buf.back; buf.back; buf.cut }

  specify { subject.must_equal '34'; buf.to_s.must_equal '012ABCDE' }

end

describe 'srch_fwd' do
  let(:buf) { Buffer.new 'Now is the time for all good men' }
  subject {  buf.srch_fwd 'good'; buf.at }

  specify {  subject.must_equal 'g' }

end

describe 'srch_fwd for non-existing string' do
  let(:buf) { Buffer.new 'Now is the time fo all good men' }
  subject {  buf.srch_fwd 'xyzzy'; buf.at }

  specify {  subject.must_equal 'N' }

end

describe 'srch_back' do
  let(:buf) { Buffer.new 'Now is the time for good men' }
  subject {  buf.fin; buf.srch_back('good'); buf.at }
  specify {  subject.must_equal 'g' }

end

describe 'srch_back for non-existant regex' do
  let(:buf) { Buffer.new 'Now is the time for all good men' }
  subject {  buf.fin; buf.srch_back 'xyzz'; buf.at }

  specify {  subject.must_equal nil }

end

describe 'del a lot of content' do
  let(:buf) { Buffer.new '' }
  subject {  buf.ins 'abcde'; buf.del 'abcde' }

  specify { subject.must_equal 'abcde'; buf.to_s.must_equal '' }

end

describe 'del_at' do
  let(:buf) {Buffer.new 'abcd' }
  subject { buf.fwd; buf.del_at }

  specify { subject.must_equal 'b'; buf.to_s.must_equal 'acd' }

end

describe 'overwrite!' do
  let(:buf) {Buffer.new 'abcd' }
  subject { buf.overwrite! '0123'; buf.to_s }

  specify { subject.must_equal '0123' }

end

describe 'should_save?' do
  let(:buf) {Buffer.new 'line 1' }
  subject { buf.should_save? }

  specify { subject.must_equal false }

end

describe 'goto_position' do
  let(:buf) {Buffer.new 'hello world' }
  subject { buf.goto_position 5; buf.position }

  specify { subject.must_equal 5 }

end

describe 'goto_position backwards' do
  let(:buf) {Buffer.new 'hello world' }
  subject { buf.fin; buf.goto_position 5; buf.position }

  specify { subject.must_equal 5 }

end

describe 'remember' do
  let(:buf) {Buffer.new "line 1\n" }
  subject { buf.remember do |b|
      b.fin
      b.ins "line 2\n"
    end 
      buf.line
  }


  specify { subject.must_equal "line 1\n" }

end

describe 'remember absolute position' do
  let(:buf) {Buffer.new 'hello world' }
  subject { buf.goto_position(5); 
    buf.remember do |b|
       b.ins('xxxxx') 
    end
buf.position 
  }

  specify { subject.must_equal 5 }
end
