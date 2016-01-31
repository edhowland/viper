# command_bindings_spec.rb - specs for command_bindings

require_relative 'spec_helper'

describe 'q' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf,  "q" }

  specify {subject.must_equal :quit }
end


describe 'q!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf,  "q!" }

  specify { -> { subject }.must_raise SystemExit }
end

describe 'w' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "w" }

  specify { subject }
end

describe 'w c.rb' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec/c.rb" }
  subject { buf.ins 'xxx'; parse_execute buf, "w #{SRC_ROOT}/spec/d.rb" }

  specify { subject; File.exist?("#{SRC_ROOT}/spec/c.rb").wont_equal true; File.exist?("#{SRC_ROOT}/spec/d.rb").must_equal true }
end

describe 'wq' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "wq" }

  specify { ->{ subject }.must_raise SystemExit }
end


describe 'rew!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "rew!" }

  specify {-> { subject }.must_raise NonRestorableException  }
end

describe 'r' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "r #{SRC_ROOT}/spec_helper.rb" }

  specify {subject; buf.to_s.must_be_empty  }
end

describe 'r' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "r #{SRC_ROOT}/spec/spec_helper.rb" }

  specify {subject; buf.to_s.wont_be_empty  }
end


describe 'r!' do
  let(:buf) { Buffer.new 'xxxx' }
  subject { parse_execute buf, "r! date" }

  specify { subject; buf.to_s.length.must_equal 33 }
end


describe 'g' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'goto' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'n' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'p' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'o' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'k!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'yank' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'help' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'check' do
  let(:buf) { FileBuffer.new "#{SRC_ROOT}/spec/spec_helper.rb" }
  subject { parse_execute buf, "check" }

  specify { subject }
end


describe 'pipe' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'pipe!' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'lint' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'new' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'report' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'slist' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'list' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'sedit' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'snip' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'apply' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'dump' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'load' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'assocx' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'assocf' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'assocd' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'tab' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'load_cov' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'cov' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'cov_report' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end


describe 'nop' do
  let(:buf) { Buffer.new '' }
  subject { parse_execute buf, "" }

  specify { skip 'not yet implemented' }
end
