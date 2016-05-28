# snippets_spec.rb - specs for snippets

require_relative 'spec_helper'

describe 'load_snippets' do
  before { $snippet_cascades = {} }
  subject { load_snippets :ruby, 'ruby' }

  specify { subject; $snippet_cascades.wont_be_empty }
end

describe 'apply_snippets' do
  before { load_snippets :ruby, 'ruby' }
  let(:buf) { Buffer.new '' }
  subject { apply_snippet :ruby, 'def', buf }

  specify { subject; buf.to_s.must_equal "def \n  ^.\nend\n" }
end

describe 'handle_tab' do
  before { load_snippets :ruby, 'ruby'; $file_associations.ext '.rb', :ruby }
  let(:buf) { FileBuffer.new 'file.rb' }
  subject { handle_tab buf; buf.to_s }

  specify { buf.association.must_equal :ruby }
  specify { subject.must_equal '  ' }

end

describe 'handle_tab with snippet' do
  before { load_snippets :ruby, 'ruby'; $file_associations.ext '.rb', :ruby }
  let(:buf) { FileBuffer.new 'file.rb' }
  subject { apply_snippet :ruby, 'def', buf; buf.ins 'my'; handle_tab buf; buf.to_s }

  specify { subject.must_equal "def my\n  \nend\n" }
end

describe 'handle_tab: locates a snippet and applies it' do
  before { load_snippets :ruby, 'ruby'; $file_associations.ext '.rb', :ruby }
  let(:buf) { FileBuffer.new 'file.rb' }
  subject { buf.ins 'def'; handle_tab(buf); buf.to_s }

  specify { subject.must_equal "def \n  ^.\nend\n" }
end

describe 'handle_back_tab' do
  let(:buf) { Buffer.new '    ' }
  subject { buf.fin; handle_back_tab(buf); buf.line }

  specify { subject.must_equal '  ' }
end

describe 'handle_return' do
  let(:buf) { Buffer.new "  " }
  subject { buf.fin; handle_return(buf); buf.to_s }

  specify { subject.must_equal "  \n  " }
end

describe 'handle_return when indented twice' do
  let(:buf) { Buffer.new '    ' }
  subject { buf.fin; handle_return(buf); buf.to_s }

  specify { subject.must_equal "    \n    " }
end
describe 'handle_return with no indentation' do
  let(:buf) { Buffer.new '' }
  subject { buf.fin; handle_return(buf); buf.to_s }

  specify { subject.must_equal "\n" }
end
