# syntax_parser_spec.rb - specs for syntax_parser

require_relative 'spec_helper'
require './parser'


describe 'question - zero or one - zero' do
  let(:buf) { Buffer.new '  word' }
  subject { question { match_word(buf) } }

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
