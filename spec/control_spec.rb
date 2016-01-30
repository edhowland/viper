# control_spec.rb - specs for control

require_relative 'spec_helper'

describe 'gets exception' do
  subject { Viper::Control.loop do |w|
      raise BindingNotFound.new
    end
 }


  specify { subject }
end
