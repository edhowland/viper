# key_press_spec.rb - specs for key_press

require_relative 'spec_helper'
describe 'All possible key strings' do
  @map = key_mappings

  @map.each_pair do |k,v|
    describe "key : #{k} value #{v}" do
      before { $stdin = StringIO.new k }
      subject { map_key(key_press) }

      specify { subject.must_equal v }
    end
  end
end
