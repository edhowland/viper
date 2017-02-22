# executor_spec.rb - specs for executor

require_relative 'spec_helper'

describe Executor do
  let(:exc) { Executor.new }
  let(:env) { {in: nil, out: nil, err: nil, frames: [{xx: 'hello'}] } }
end

