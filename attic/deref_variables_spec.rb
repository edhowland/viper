# deref_variables_spec.rb - specs for deref_variables

require_relative 'spec_helper'

describe 'decurly' do
  let(:str) { ':{foo}' }
  subject { decurly str }
  it 'should be foo' do
    subject.must_equal 'foo'
  end
  describe 'with no curly: foo' do
    let(:str) { 'foo' }
    subject { decurly str }
    it 'should be nil' do
      subject.must_equal '_not_found'
    end
  end
end

describe 'deref_variables' do
let(:vars) { Viper::VFS["viper"]["variables"] }
  describe '"say :hi"' do
    let(:str) { ":hi" }
    subject { deref_variables str }
    before { vars[:hi] = "hello world" }
    it 'should be "hello world"' do
      subject.must_equal "hello world"
    end
  end
  describe '"none :xx none"' do
    let(:str) { "none :xx none" }
    before { vars[:xx] = 'xyzzy' }
    subject { deref_variables str }
    it 'should be "none xyzzy none"' do
      subject.must_equal "none xyzzy none"
    end
  end
  describe 'no var "bye"' do
    let(:str) { "bye" }
    subject { deref_variables str }
    it 'should be "bye"' do
      subject.must_equal "bye"
    end
  end
  describe 'with embedded curlys /tmp/:{foo}/xxx' do
    let(:str) { '/tmp/:{foo}/xxx' }
    before { vars[:foo] = 'bar' }
    subject { deref_variables str }
    it 'should be /tmp/bar/xxx' do
      subject.must_equal '/tmp/bar/xxx'
    end
  end
end
