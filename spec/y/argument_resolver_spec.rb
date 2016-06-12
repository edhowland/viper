# argument_resolver_spec.rb - specs for argument_resolver

require_relative 'spec_helper'

describe ArgumentResolver do
  describe ':redirect_to file' do
    let(:env) { {in: nil, out: nil, err: nil, frames: [{}] } }
    let(:res) { ArgumentResolver.new env }
    subject { res.resolve [:redirect_to, 'file'] }
    it 'should be nil' do
      subject.must_equal nil
    end
    it 'should set env[:out] to a File object' do
      subject
      env[:out].must_be_instance_of File
    end
    it 'should mark :closers with :out' do
      subject
      env[:closers].wont_be_nil
      env[:closers].must_equal [:out]
    end
    after { env[:out].close if env[:out].instance_of?(File) }
  end
  describe 'redirect_from file' do
    let(:env) { {in: nil, out: nil, err: nil, frames: [{}] } }
    let(:res) { ArgumentResolver.new env }    
    subject { res.resolve [:redirect_from, 'file'] }
    it 'should be nil' do
      subject.must_equal nil
    end
    it 'should set :in to File object' do
      subject
      env[:in].must_be_instance_of File
    end
    it 'should set :closers to :in' do
      subject
      env[:closers].wont_be_nil
      env[:closers].must_equal [:in]
    end
    after { env[:in].close if env[:in].instance_of? File }

  end
  describe ':append_to file' do
    let(:env) { {in: nil, out: nil, err: nil, frames: [{}] } }
    let(:res) { ArgumentResolver.new env }    
    subject { res.resolve [:append_to, 'file'] }
    it 'should be nil' do
      subject.must_equal nil
    end
    it 'should be instance of file' do
      subject
      env[:out].must_be_instance_of File
    end
    it 'should set :closers to :out' do
      subject
      env[:closers].wont_be_nil
      env[:closers].must_equal [:out]
    end
    after { env[:out].close if env[:out].instance_of?(File) }
  end
end
