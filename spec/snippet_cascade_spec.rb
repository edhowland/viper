# snippet_cascade_spec.rb - specs for snippet_cascade

require_relative 'spec_helper'

describe 'single hash' do
  let(:snip) { SnippetCascade.new(:a => 1, :b => 2) }
  subject { snip[:a] }

  specify { subject.must_equal 1 }

end

describe '<< new_hash' do
  let(:snip_h) { {:a => 1} }
  let(:snip_h2) { {:a => 2} }
  let(:snip) { SnippetCascade.new(snip_h) }
  subject { snip << snip_h2 }

  specify { subject }
end

describe 'shadows earlier key' do
  let(:snip_h) { {:a => 1} }
  let(:snip_h2) { {:a => 2} }
  let(:snip) { SnippetCascade.new(snip_h) }
  subject { snip << snip_h2; snip[:a] }

  specify { subject.must_equal 2 }
end
