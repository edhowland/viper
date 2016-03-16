# command_bindings_spec.rb - specs for command_bindings

require_relative 'spec_helper'

# supress any audio from say command
$audio_suppressed = true
describe 'command_bindings' do
  before { Viper::Session[:commands] = command_bindings }
  describe 'q' do
    let(:buf) { Buffer.new '' }
    subject { perform!('q') { buf } }

    specify { subject.must_equal :quit }
  end

  describe 'q!' do
    let(:buf) { Buffer.new '' }
    subject { perform!('q!') { buf } }

    specify { -> { subject }.must_raise SystemExit }
  end

  describe 'w' do
    let(:buf) { Buffer.new '' }
    subject { perform!('w') { buf } }

    specify { subject }
  end

  describe 'w c.rb' do
    let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec/c.rb" }
    subject { buf.ins 'xxx'; perform!("w #{SRC_ROOT}/spec/d.rb") { buf } }

    specify { subject; File.exist?("#{SRC_ROOT}/spec/c.rb").wont_equal true; File.exist?("#{SRC_ROOT}/spec/d.rb").must_equal true }
    after { File.unlink "#{SRC_ROOT}/spec/d.rb" }
  end

  describe 'wq' do
    let(:buf) { Buffer.new '' }
    subject { perform!('wq') { buf } }

    specify { -> { subject }.must_raise SystemExit }
  end

  describe 'rew!' do
    let(:buf) { Buffer.new '' }
    subject { perform!('rew!') { buf } }

    specify { -> { subject }.must_raise NonRestorableException }
  end

  describe 'r' do
    let(:buf) { Buffer.new '' }
    subject { perform!("r #{SRC_ROOT}/spec_helper.rb") { buf } }

    specify { subject; buf.to_s.must_be_empty }
  end

  describe 'r' do
    let(:buf) { Buffer.new '' }
    subject { perform!("r #{SRC_ROOT}/spec/spec_helper.rb") { buf } }

    specify { subject; buf.to_s.wont_be_empty }
  end

  describe 'r!' do
    let(:buf) { Buffer.new 'xxxx' }
    subject { perform!('r! date') { buf } }

    specify { subject; buf.to_s.length.must_equal 33 }
  end

  describe 'g 9' do
    let(:buf) { Buffer.new "line 1\nline 2\nline 3\nline 4\nline 5\nline 6\nline 7\nline 8\nline 9\nline 10\n" }
    subject { perform!('g 9') { buf } }

    specify { subject; buf.line_number.must_equal 9 }
  end

  describe 'goto' do
    let(:buf) { Buffer.new 'abcdef' }
    subject { perform!('goto 4') { buf } }

    specify { subject; buf.at.must_equal 'e' }
  end

  describe 'n' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear; perform!('new') { buf }; perform!('new') { buf } }
    subject { perform!('n') { buf }; $buffer_ring.first.name }

    specify { subject.must_equal 'Scratch 1' }
  end

  describe 'p' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear;  perform!('new') { buf }; perform!('new') { buf } }
    subject { perform!('p') { buf }; $buffer_ring.first.name }

    specify { $buffer_ring.length.must_equal 2 }
    specify { subject.must_equal 'Scratch 1' }
  end

  describe 'o spec_helper.rb' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear }
    subject { perform!("o #{SRC_ROOT}/spec/spec_helper.rb") { buf } }

    specify { subject; $buffer_ring.length.must_equal 1 }
  end

  describe 'k!' do
    before { $buffer_ring.clear }
    let(:buf) { Buffer.new '' }
    subject { perform!('new') { buf }; perform!('k!') { buf } }

    specify { subject; $buffer_ring.length.must_equal 0 }
  end

  describe 'yank' do
    let(:buf) { Buffer.new 'xyzzy' }
    subject { buf.beg; buf.set_mark; buf.fin; perform!('yank') { buf }; $clipboard }

    specify { subject.must_equal 'xyzzy' }
  end

  describe 'help' do
    before { $buffer_ring.clear }
    let(:buf) { Buffer.new '' }
    subject { perform!('help') { buf } }

    specify { subject; $buffer_ring.first.name.must_equal 'Help Buffer (read only)' }
  end

  describe 'pipe' do
    let(:buf) { Buffer.new 'puts "hello world!"' }
    subject { perform!('pipe ruby -c') { buf } }

    specify { subject }
  end

  describe 'pipe!' do
    let(:buf) { Buffer.new 'puts 1' }
    subject { perform!('pipe! ruby -c') { buf } }

    specify { subject; buf.to_s.must_equal "Syntax OK\n" }
  end

  describe 'new' do
    before { $buffer_ring.clear }
    let(:buf) { Buffer.new '' }
    subject { perform!('new') { buf } }

    specify { subject; $buffer_ring.length.must_equal 1 }
  end

  describe 'report' do
    let(:buf) { Buffer.new '' }
    subject { perform!('report') { buf } }

    specify { subject }
  end

  describe 'slist' do
    let(:buf) { Buffer.new '' }
    subject { perform!('slist') { buf } }

    specify { subject }
  end

  describe 'list' do
    let(:buf) { Buffer.new '' }
    before { perform!('load ruby ruby') { buf } }
    subject { perform!('list ruby') { buf } }

    specify { subject }
  end

  describe 'sedit' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear; perform!('new') { buf }; perform!('load ruby ruby') { buf } }
    subject { perform!('sedit def ruby') { $buffer_ring.first } }

    specify { subject; $buffer_ring.first.to_s[0..2].must_equal 'def' }
  end

  describe 'sedit - snippet not found' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear; perform!('new') { buf }; perform!('load ruby ruby') { buf } }
    subject { perform!('sedit xxx ruby') { $buffer_ring.first } }

    specify { -> { subject }.must_raise SnippetNotFound }
  end

  describe 'sedit - collection not found' do
    let(:buf) { Buffer.new '' }
    before { $buffer_ring.clear; perform!('new') { buf }; perform!('load ruby ruby') { buf } }
    subject { perform!('sedit xxx yyy') { $buffer_ring.first } }

    specify { -> { subject }.must_raise SnippetCollectionNotFound }
  end

  describe 'snip' do
    let(:buf) { Buffer.new '' }
    before { perform!('load ruby ruby') { buf }; perform!('new') { buf }; $buffer_ring.first.ins 'my' }
    subject { perform!('snip my ruby') { $buffer_ring.first } }

    specify { subject; $snippet_cascades[:ruby]['my'].must_equal 'my' }
  end

  describe 'apply' do
    before { $snippet_cascades.clear; perform!('load ruby ruby') { buf } }
    let(:buf) { Buffer.new '' }
    subject { perform!('apply def ruby') { buf }; buf.to_s[0..2] }

    specify { subject.must_equal 'def' }
  end

  def cfg_path(fname)
    "#{SRC_ROOT}/config/#{fname}"
  end

  describe 'dump' do
    let(:buf) { Buffer.new '' }
    let(:bind) { command_bindings }
    subject do
      stub(:dump_snippets, nil) do
        bind[:dump].call(buf, 'ruby', 'ruby')
      end
    end

    specify { subject }
  end

  # load not checked since it is used in previous tests

  describe 'assocx' do
    let(:buf) { Buffer.new '' }
    subject { perform!('assocx .rb ruby') { buf }; FileBuffer.new('file.rb').association }

    specify { subject.must_equal :ruby }
  end

  describe 'assocf' do
    let(:buf) { Buffer.new '' }
    subject { perform!('assocf /.+_spec.rb/ spec') { buf }; FileBuffer.new('my_spec.rb').association }

    specify { subject.must_equal :spec }
  end

  describe 'assocd' do
    let(:buf) { Buffer.new '' }
    subject { perform!('assocd /h/b/ markdown') { buf }; FileBuffer.new('/h/b/file.md').association }

    specify { subject.must_equal :markdown  }
  end

  describe 'tab' do
    before { $snippet_cascades[:default] = {} }
    let(:buf) { Buffer.new 'def ' }
    subject { buf.fin; perform!('tab') { buf }; buf.to_s }

    specify { subject.must_equal 'def   ' }
  end

  describe 'nop' do
    let(:buf) { Buffer.new '' }
    subject { perform!('nop I said') { buf } }

    specify { subject }
  end

  describe 'keys - keyboard help' do
    before { $stdin = StringIO.new "\u0011" }
    let(:buf) { Buffer.new '' }
    subject { perform!('keys') { buf } }

    specify { subject }
  end

  describe 'say' do
    let(:buf) { Buffer.new '' }
    let(:bind) { command_bindings }
    subject { prc = bind[:say]; prc.call buf }

    specify { subject }
  end

  describe 'nop' do
    let(:buf) { Buffer.new '' }
    let(:bind) { command_bindings }
    subject { prc = bind[:nop]; prc.call buf, 1, 2 }

    specify { subject }
  end

end # top level describe 'command_bindings' do

describe 'package' do
  let(:buf) { Buffer.new '' }
  let(:bind) { command_bindings }
  let(:mock) { MiniTest::Mock.new }
  before do
    mock.expect(:load, nil)
  end

  subject do
    Viper::Package.stub(:new, mock) do
      bind[:package].call(buf, 'xyzzy')
    end
  end

  specify { subject; mock.verify }
end

describe 'package_info' do
  let(:buf) { Buffer.new '' }
  let(:bind) { command_bindings }
  subject do
    stub(:package_info, '') do
      bind[:package_info].call(buf, 'viper_debug')
    end
  end

  specify { subject }
end

describe 'lint' do
  let(:buf) { Buffer.new '' }
  let(:bind) { command_bindings }
  subject do
    stub(:check_lang_lint, true) do
      bind[:lint].call(buf)
    end
  end

  specify { subject }
end

describe 'check - syntax of buffer contents' do
  let(:buf) { Buffer.new '' }
  let(:bind) { command_bindings }
  subject do
    stub(:check_lang_syntax, true) do
      bind[:check].call(buf)
    end
  end

  specify { subject }
end
