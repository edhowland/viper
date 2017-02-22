# syntax_parser_spec.rb - specs for syntax_parser

require_relative 'spec_helper'

describe 'question - zero or one - zero' do
  let(:buf) { Buffer.new '  word' }
  subject { question { match_word(buf) } }

  specify { subject.must_equal true }
end

describe 'nonterm_quote' do
  let(:buf) { Buffer.new "'hello world'" }
  subject { nonterm_quote(buf) }

  specify { subject.must_equal true }
end

describe 'nonterm_quote unterminated string' do
  let(:buf) { Buffer.new "'hello" }
  subject { nonterm_quote(buf) }

  specify { -> { subject }.must_raise CommandSyntaxError }
end

describe 'nonterm_dblquote' do
  let(:buf) { Buffer.new '"hello world "' }
  subject { nonterm_dblquote(buf) }

  specify { subject.must_equal true }
end

describe 'nonterm_dblquote - unterminated string' do
  let(:buf) { Buffer.new '"hello' }
  subject { nonterm_dblquote(buf) }

  specify { -> { subject }.must_raise CommandSyntaxError }
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
  let(:buf) { Buffer.new '  command' }
  subject { question { match_whitespace(buf) } }

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

describe 'plus' do
  before { @count = 0 }
  subject { plus { @count += 1; @count == 2 } }

  specify { subject; @count.must_equal 1 }
end

describe 'multiline commands' do
  let(:str) { "say hi\nsay bye" }
  subject { parse! str }
  it 'should be a 2 element sexps array' do
    subject.must_be_instance_of Array
    subject.length.must_equal 2
  end
  it 'should be [:say "hi"][:say, "bye"]' do
    subject[0].must_equal [:say, ['hi']]
    subject[1].must_equal [:say, ['bye']]
  end
end

describe 'match_newline' do
  let(:buf) { Buffer.new "\n" }
  subject { match_newline buf }
  it 'should be true' do
    subject.must_equal true
  end
end
describe 'match_newline_or_semicolon' do
  let(:buf) { Buffer.new "\n" }
  subject { match_newline_or_semicolon buf }
  it 'should be true' do
    subject.must_equal true
  end
end
describe 'match_newline_or_semicolon' do
  let(:buf) { Buffer.new ';' }
  subject { match_newline_or_semicolon buf }
  it 'should be true' do
    subject.must_equal true
  end
end
describe 'match_newline_or_semicolon with non matching contents' do
  let(:buf) { Buffer.new 'xyzzy' }
  subject { match_newline_or_semicolon buf }
  it 'should be false' do
    subject.must_equal false
  end
end