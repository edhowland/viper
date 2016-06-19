# parser_spec.rb - specs for parser

require_relative 'spec_helper'

describe Visher do
  describe 'when parsing empty string' do
    let(:str) { '' }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end
  end
  describe 'when parsing single octothorpe' do
    let(:str) { '#' }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end
    
  end
  describe 'when parsing full comment' do
    let(:str) { '  # comment' }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end

  end
  describe 'when parsing newline' do
    let(:str) { "\n" }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end

  end
  describe 'when parsing simple statement: ls' do
    let(:str) { 'ls' }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end
  end
  describe 'when parsing ls # trailing comment' do
    let(:str) { 'ls # comment' }
    subject { Visher.check! str }
    it 'should be true' do
      subject.must_equal true
    end
  end
end
