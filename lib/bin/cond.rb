# cond.rb: class Cond implements cond expression
# Syntax:
# cond { test -f /v/moot/d } { echo /v/moot/d exists } { test -f /v/moot/f } { echo /v/moot/f exists } else { echo nothing exists }

class Cond < BaseCommand
  def initialize
    super
    @truth = Visher.parse!('true')
  end
  attr_reader :truth
  def call(*args, env:, frames:)
    result = true
    super do |*a|
      raise VishSyntaxError.new("cond: requires one or more of predicate, action clauses. Args length  was #{a.length}, and was not a multiple of 2") if (a.length % 2) != 0
      if a.length >= 4 && a[-2] == 'else'
        a[-2] = @truth
      end
      raise VishSyntaxError.new("cond: all arguments must be blocks, but 1 or more were not") unless a.all? {|e| e.instance_of?(Block) }

        clauses = a.each_slice(2).to_a
      candidate = clauses.detect {|j| j[0].call(env: @ios, frames: @fs) }
      if !candidate.nil?
        result = candidate[1].call(env: @ios, frames: @fs)
        @fs.merge
      else
        result = false
      end

    end
    result
  end
end
