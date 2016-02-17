# syntax_parser_spec.rb - specs for syntax_parser

require_relative 'spec_helper'


describe 'question - zero or one - zero' do
  let(:buf) { Buffer.new '  word' }
  subject { question { match_word(buf) } }

  specify { subject.must_equal true }
end

describe 'nonterm_string single quotes' do
  let(:buf) { Buffer.new "'string'" }
  subject { nonterm_string buf }

  specify { subject.must_equal true }
end

describe 'nonterm_string double quotes' do
  let(:buf) { Buffer.new '"hello world"' }
  subject { nonterm_string(buf) }

  specify { subject.must_equal true }
end

describe 'question 0 or 1 - one' do
  let(:buf) { Buffer.new '  command'  }
  subject { question { match_whitespace(buf)} }

  specify { subject.must_equal true }
end

describe 'question - 0 or 1 - two is false' do
  let(:buf) { Buffer.new '##' }
  subject { question { match_octothorpe(buf) } }

  specify { subject.must_equal false }
end

describe 'complex multi-expr command with comment - ok' do
  let(:buf) { Buffer.new "say 'hellow world';com arg;nop# this is a comment" }
  subject { syntax_ok? buf }

  specify { subject }
end

describe 'syntax_ok? empty string' do
  let(:buf) { Buffer.new '' }
  subject { syntax_ok? buf }

  specify { subject.must_equal true }
end

describe 'syntax_ok? double quotes' do
  let(:buf) { Buffer.new 'say "hello"' }
  subject { syntax_ok? buf }

  specify { subject.must_equal true }
end

describe 'errorfails with true' do
  let(:buf) { Buffer.new 'hello world' }
  subject { error { match_end(buf) } }

  specify { subject.must_equal true }
end

describe 'error returns false for true expression' do
  let(:buf) { Buffer.new '' }
  subject { error { match_end(buf) } }
end
