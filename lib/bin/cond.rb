# cond.rb: class Cond implements cond expression
# Syntax:
# cond { test -f /v/moot/d } { echo /v/moot/d exists } { test -f /v/moot/f } { echo /v/moot/f exists } else { echo nothing exists }

class Cond < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      raise VishSyntaxError.new("cond: requires one or more of predicate, action clauses. Args length  was #{a.length}, and was not a multiple of 2") if (a.length % 2) != 0
      eblk, _else = *a.reverse
      raise VishSyntaxError.new("cond syntax error") if eblk.nil? ||  !eblk.respond_to?(:call)
      _else = _else == "else"


      fin = _else ? -3 : -1 

        clauses = a[0..(fin)].each_slice(2).to_a
      result = clauses.reduce(false) do |i, j|
        if !i
          pred = j[0].call(env: env, frames: frames)
          j[1].call(env: env, frames: frames) if pred
          pred
        else
#        puts "in else inside reduce block"
          false
        end
      end
#      puts "result : #{result}"
      if !result && _else
#        puts "should run else clause"
        result = eblk.call(env: env, frames: frames)
      end
      @fs.merge

      result
    end
  end
end
