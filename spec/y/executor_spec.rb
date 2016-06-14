# executor_spec.rb - specs for executor

require_relative 'spec_helper'

describe Executor do
  let(:exc) { Executor.new }
  let(:env) { {in: nil, out: nil, err: nil, frames: [{xx: 'hello'}] } }
  describe 'deref takes level 0 array' do
    let(:arg) { [:deref, :xx] }
    subject { exc.deref arg, env:env }
    it 'should be "hello"' do
      subject.must_equal "hello"
    end
  end
  describe 'when arg level 1: [redirect_to, [:deref, :xx]]' do
    let(:arg) { [:redirect_to, [:deref, :xx]] }
    subject { exc.deref arg, env:env }
    it 'should be [:redirect_to, \'hello\']' do
      subject.must_equal [:redirect_to, 'hello']
    end
  end
  
  # test possible bug
  describe 'redirect_from with :deref inside' do
    let(:env) { {in: nil, out: nil, err: nil, frames: [{aa: 'cc'}] } }
    let(:arg) { [:redirect_from, [:deref, :aa]] }
    subject { exc.deref arg, env:env }
    it 'should be [:redirect_from, '']' do
      subject.must_equal [:redirect_from, 'cc']
    end
  end
  describe 'deref_possible?' do
    let(:arg) { 'cc' }
    subject { exc.deref_possible? arg }
    it 'should be false' do
      subject.must_equal false
    end
  end
  describe 'deref_possible? [:redirect_from, "cc"]' do
    let(:arg) { [:redirect_from, 'cc'] }
        subject { exc.deref_possible? arg }
    it 'should be false' do
      subject.must_equal false
    end
  end
  describe 'deref_possible? [:deref, :aa]' do
    let(:arg) { [:deref, :aa] }
    subject { exc.deref_possible? arg }
    it 'should be true' do
      subject.must_equal true
    end
  end
  describe 'deref_possible [:redirect_from, [:deref, :aa]]' do
    let(:arg) { [:redirect_from, [:deref, :aa]] }
    subject { exc.deref_possible? arg }
    it 'should be true' do
      subject.must_equal true
    end
  end
end
