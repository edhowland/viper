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
