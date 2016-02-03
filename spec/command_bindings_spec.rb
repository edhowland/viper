# command_bindings_spec.rb - specs for command_bindings

require_relative 'spec_helper'

# supress any audio from say command
$audio_suppressed = true

describe 'q' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'q' }

  specify { subject.must_equal :quit }
end

describe 'q!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'q!' }

  specify { -> { subject }.must_raise SystemExit }
end

describe 'w' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'w' }

  specify { subject }
end

describe 'w c.rb' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec/c.rb" }
  subject { buf.ins 'xxx'; parse_execute buf, "w #{SRC_ROOT}/spec/d.rb" }

  specify { subject; File.exist?("#{SRC_ROOT}/spec/c.rb").wont_equal true; File.exist?("#{SRC_ROOT}/spec/d.rb").must_equal true }
  after { File.unlink "#{SRC_ROOT}/spec/d.rb" }
end

describe 'wq' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'wq' }

  specify { -> { subject }.must_raise SystemExit }
end

describe 'rew!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'rew!' }

  specify { -> { subject }.must_raise NonRestorableException }
end

describe 'r' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "r #{SRC_ROOT}/spec_helper.rb" }

  specify { subject; buf.to_s.must_be_empty }
end

describe 'r' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "r #{SRC_ROOT}/spec/spec_helper.rb" }

  specify { subject; buf.to_s.wont_be_empty }
end

describe 'r!' do
  let(:buf) { Buffer.new 'xxxx' }
  subject { parse_execute buf, 'r! date' }

  specify { subject; buf.to_s.length.must_equal 33 }
end

describe 'g 14' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec_helper.rb" }
  subject { parse_execute buf, 'g 14 ' }

  specify { subject; buf.line_number.must_equal 14 }
end

describe 'goto' do
  let(:buf) { Buffer.new 'abcdef' }
  subject { parse_execute buf, 'goto 4' }

  specify { subject; buf.at.must_equal 'e' }
end

describe 'n' do
  let(:buf) { Buffer.new '' }
  before { $buffer_ring.clear; parse_execute buf, 'new'; parse_execute buf, 'new' }
  subject { parse_execute buf, 'n'; $buffer_ring.first.name }

  specify { subject.must_equal 'Scratch 1' }
end

describe 'p' do
  let(:buf) { Buffer.new '' }
  before { $buffer_ring.clear;  parse_execute buf, 'new'; parse_execute buf, 'new' }
  subject { parse_execute buf, 'p'; $buffer_ring.first.name }

  specify { $buffer_ring.length.must_equal 2 }
  specify { subject.must_equal 'Scratch 1' }
end

describe 'o spec_helper.rb' do
  let(:buf) { Buffer.new '' }
  before { $buffer_ring.clear }
  subject { parse_execute buf, "o #{SRC_ROOT}/spec/spec_helper.rb" }

  specify { subject; $buffer_ring.length.must_equal 1 }
end

describe 'k!' do
  before { $buffer_ring.clear }
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'new'; parse_execute buf, 'k!' }

  specify { subject; $buffer_ring.length.must_equal 0 }
end

describe 'yank' do
  let(:buf) { Buffer.new 'xyzzy' }
  subject { buf.beg; buf.set_mark; buf.fin; parse_execute buf, 'yank'; $clipboard }

  specify { subject.must_equal 'xyzzy' }
end

describe 'help' do
  before { $buffer_ring.clear }
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'help' }

  specify { subject; $buffer_ring.first.name.must_equal 'Help Buffer (read only)' }
end

describe 'check' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec_helper.rb" }
  subject { parse_execute buf, 'check' }

  specify { subject }
end

describe 'pipe' do
  let(:buf) { Buffer.new 'puts "hello world!"' }
  subject { parse_execute buf, 'pipe ruby -c' }

  specify { subject }
end

describe 'pipe!' do
  let(:buf) { Buffer.new 'puts 1' }
  subject { parse_execute buf, 'pipe! ruby -c' }

  specify { subject; buf.to_s.must_equal "Syntax OK\n" }
end

describe 'lint' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec_helper.rb" }
  subject { parse_execute buf, 'lint' }

  specify { subject }
end

describe 'new' do
  before { $buffer_ring.clear }
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'new' }

  specify { subject; $buffer_ring.length.must_equal 1 }
end

describe 'report' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'report' }

  specify { subject }
end

describe 'slist' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'slist' }

  specify { subject }
end

describe 'list' do
  let(:buf) { Buffer.new '' }
  before { parse_execute buf, 'load ruby ruby' }
  subject { parse_execute buf, 'list ruby' }

  specify { subject }
end

describe 'sedit' do
  let(:buf) { Buffer.new '' }
  before { $buffer_ring.clear; parse_execute buf, 'new'; parse_execute buf, 'load ruby ruby' }
  subject { parse_execute $buffer_ring.first, 'sedit def ruby' }

  specify { subject; $buffer_ring.first.to_s[0..2].must_equal 'def' }
end

describe 'snip' do
  let(:buf) { Buffer.new '' }
  before { parse_execute buf, 'load ruby ruby'; parse_execute buf, 'new'; $buffer_ring.first.ins 'my' }
  subject { parse_execute $buffer_ring.first, 'snip my ruby' }

  specify { subject; $snippet_cascades[:ruby]['my'].must_equal 'my' }
end

describe 'apply' do
  before { $snippet_cascades.clear; parse_execute buf, 'load ruby ruby' }
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'apply def ruby'; buf.to_s[0..2] }

  specify { subject.must_equal 'def' }
end

def cfg_path(fname)
  "#{SRC_ROOT}/config/#{fname}"
end

describe 'dump' do
  let(:buf) { Buffer.new '' }
  before { File.unlink(cfg_path('my.json')) if File.exist?(cfg_path('my.json')); $snippet_cascades.clear }
  subject { buf.ins 'my'; parse_execute buf, 'snip my my'; parse_execute buf, 'dump my my'; File.exist?(cfg_path('my.json')) }

  specify { subject.must_equal true }
  after { File.unlink(cfg_path('my.json')) }
end

# load not checked since it is used in previous tests

describe 'assocx' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'assocx .rb ruby'; FileBuffer.new('file.rb').association }

  specify { subject.must_equal :ruby }
end

describe 'assocf' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'assocf /.+_spec.rb/ spec'; FileBuffer.new('my_spec.rb').association }

  specify { subject.must_equal :spec }
end

describe 'assocd' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'assocd /h/b/ markdown'; FileBuffer.new('/h/b/file.md').association }

  specify { subject.must_equal :markdown  }
end

describe 'tab' do
  before { $snippet_cascades[:default] = {} }
  let(:buf) { Buffer.new 'def ' }
  subject { buf.fin; parse_execute buf, 'tab'; buf.to_s }

  specify { subject.must_equal 'def   ' }
end

describe 'load_cov' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "load_cov #{SRC_ROOT}/coverage/coverage.json"; Viper::Session[:coverage] }

  specify { subject.wont_equal nil }
end

describe 'cov' do
  before { parse_execute buf, "load_cov #{SRC_ROOT}/coverage/coverage.json" }
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/lib/viper.rb" }
  subject { $buffer_ring.unshift buf; parse_execute buf, 'cov'; $buffer_ring.first.to_s[0..7] }

  specify { subject.must_equal 'Coverage' }
end

describe 'cov_report' do
  before { parse_execute buf, "load_cov #{SRC_ROOT}/coverage/coverage.json" }
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'cov_report'; $buffer_ring.first.to_s[0..6] }

  specify { subject.must_equal 'Created' }
end

describe 'nop' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, 'nop I said' }

  specify { subject }
end
