# recordable_spec.rb - specs for recordable

require_relative 'spec_helper'

class MyBuffer < Buffer
  include Recordable

  attr_reader :commands
end

describe 'invert :del' do
  let(:buf) { MyBuffer.new '' }
  subject {  buf.ins('i'); buf.invert(buf.commands.back) }

  specify {  subject.must_equal [:del, 'i'] }

end
