# action_snippet.rb_spec.rb - specs for action_snippet.rb

require_relative 'spec_helper'

def expanded_path
  File.dirname(File.expand_path(__FILE__)) + '../config/' 
end

describe 'create_snippet' do
  let(:buf) {Buffer.new 'xyzzy'}
  subject { create_snippet :ruby, 'def', buf; $snippet_cascades[:ruby] }

  specify { subject.wont_be_empty } 
end

describe 'apply_snippet' do
  let(:buf) {Buffer.new '' }
  before { $snippet_cascades[:xyzzy] = {:my => 'you'} }
  subject { apply_snippet :xyzzy, :my, buf; buf.to_s }

  specify { subject.must_equal 'you' }
end

describe 'dump_snippets' do
  before { create_snippet :xyzzy, :my, 'you' }
  subject do 
    File.stub(:write, nil, [expanded_path + 'xyzzy.json', '']) do
      dump_snippets :xyzzy, 'xyzzy'
    end
  end

  specify { subject }
end
