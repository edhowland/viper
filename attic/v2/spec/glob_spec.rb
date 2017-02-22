# glob_spec.rb - specs for glob

require_relative 'spec_helper'

describe Glob do
  let(:fs) { FrameStack.new }
  describe 'when given normal StringLiteral w/no interpolation' do
    let(:glob) { Glob.new StringLiteral.new('file') }
    subject { glob.call frames:fs }
    it 'should be [file] when called' do
      subject.must_equal 'file'
    end
  end
  describe 'when given a glob *_helper.rb' do
    let(:glob) { Glob.new StringLiteral.new('*_helper.rb') }
    subject { glob.call frames:fs }
    it 'should be [ spec_helper.rb ]' do
      subject.must_equal [ 'spec_helper.rb' ]
    end
  end
end
