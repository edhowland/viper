# echo_redirection_spec.rb - specs for echo_redirection

require_relative 'spec_helper'

describe 'redirection' do
  let(:args) { ['a0', 'a1', '>', '/some/file'] }
    subject { apply_redirects(args) }

  it 'should delete only the redirected portion' do
    subject.must_equal ['a0', 'a1']
  end
end

describe 'with no redirection' do
  let(:args) { ['a0', 'a1', 'a3'] }
  subject { apply_redirects args }
  
  it 'should remain unchanged' do
    subject.must_equal ['a0', 'a1', 'a3']
  end
end

describe 'sets things in given block' do
  let(:args) { ['>>', '/path/name'] }
  before { @my_path = '' }
  subject { apply_redirects(args) {|op, path| @my_path = path } }

  it 'should have set @my_path to /path/name' do
       subject.must_equal []
    @my_path.must_equal '/path/name'
  end
end

describe 'redirection both ways' do
  let(:args) { ['<', '/input/file', '>', '/output/file'] }
  subject { apply_redirects args }
  
  it 'should be empty' do
    subject.must_equal []
  end
end
