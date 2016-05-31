
# variables_spec.rb - specs for variables

require_relative 'spec_helper'

describe 'setting a variable' do
  subject { Viper::Variables[:space] = 2; Viper::Variables[:space] }

  specify { subject.must_equal 2 }
end

describe 'set string value' do
  subject { Viper::Variables.set(:sub, 'hello'); Viper::Variables[:sub] }

  specify { subject.must_equal 'hello' }
end

describe 'set integer' do
  subject { Viper::Variables.set(:num, '1'); Viper::Variables[:num] }

  specify { subject.must_equal 1 }
end

describe 'set float' do
  subject { Viper::Variables.set(:pi, '3.1415927'); Viper::Variables[:pi] }

  specify { subject.must_equal 3.1415927 }
end

describe 'set string' do
  subject { Viper::Variables.set 'salad', 'lettuce'; Viper::Variables[:salad] }
end
