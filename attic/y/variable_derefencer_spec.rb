# variable_derefencer_spec.rb - specs for variable_derefencer

require_relative 'spec_helper'

describe VariableDerefencer do
  describe 'when empty stack frame' do
    let(:frames) { [{}] }
    let(:vref) { VariableDerefencer.new frames }
    subject { vref[:id] }
    it 'should be empty string' do
      subject.must_equal ''
    end
  end
  describe 'when given a single frame and matching symbol' do
    let(:frames) { [{devil: 'details'}] }
    let(:vref) { VariableDerefencer.new frames }

    subject { vref[:devil] }
    it 'should be details' do
      subject.must_equal 'details'
    end
  end
  
  describe 'when shadowing earlier variable' do
    let(:frames) { [{cat: 'pet'}, {}, {cat: 'evil'}] }
    let(:vref) { VariableDerefencer.new frames }
    subject { vref[:cat]  }
    it 'should be evil' do
      subject.must_equal 'evil'
    end
  end
  describe 'decurlify :{var}' do
    let(:frames) { [{var: 'hello'}] }
    let(:vref) { VariableDerefencer.new frames }
    subject {vref.decurlify ":{var}" }
    it 'should be "var"' do
      subject.must_equal "var"
    end
  end
  describe 'decurlify unknown match or empty' do
    let(:frames) { [{var: 'hello'}] }
    let(:vref) { VariableDerefencer.new frames }
    subject {vref.decurlify "" }
    it 'should be ""' do
      subject.must_equal ""
    end
  end
  describe 'interpolate_str empty string' do
    let(:frames) { [{var: 'hello'}] }
    let(:vref) { VariableDerefencer.new frames }
    let(:str) { "" }
    subject { vref.interpolate_str str }
    it 'should be empty string' do
      subject.must_equal ''
    end
    
  end
  describe 'interpolate_str with noembedded vars' do
    let(:frames) { [{var: 'hello'}] }
    let(:vref) { VariableDerefencer.new frames }
    let(:str) { "var nice" }
    subject { vref.interpolate_str str }
    it 'should be equal original str' do
      subject.must_equal str
    end
  end
  describe 'interpolate_str "xxx:{var}yyy"' do
    let(:frames) { [{var: 'hello'}] }
    let(:vref) { VariableDerefencer.new frames }
    let(:str) { "xxx:{var}yyy" }
    subject { vref.interpolate_str str }
    it 'should be xxxhelloyyy' do
      subject.must_equal 'xxxhelloyyy'
    end
  end
  describe 'interpolate_str 2 variables' do
    let(:frames) { [{var: 'hello', name: 'Edward'}] }
    let(:vref) { VariableDerefencer.new frames }
    let(:str) { ":{var} there, :{name}" }
    subject { vref.interpolate_str str }
    it 'should be hello there, Edward' do
      subject.must_equal 'hello there, Edward'
    end
  end
end
