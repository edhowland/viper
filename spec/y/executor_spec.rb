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
end
