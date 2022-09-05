# cond.rb: class Cond implements cond expression
# Syntax:
# cond { test -f /v/moot/d } { echo /v/moot/d exists } { test -f /v/moot/f } { echo /v/moot/f exists } else { echo nothing exists }

class Cond < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      eblk, _else = *a.reverse
      raise VishSyntaxError.new("cond syntax error") if eblk.nil? ||  !eblk.respond_to?(:call)
      _else = _else == "else"
      if _else
        # what to do if else clause exists
      else
        raise VishSyntaxError.new("cond requires even number of clauses") if (a.length % 2) != 0
        clauses = a.each_slice(2).to_a
      result = clauses.reduce(false) do |i, j|
        if !i
          if j[0].call(env: env, frames: frames)
            j[1].call(env: env, frames: frames)
            true
          else
            false
          end
        else
          true
        end
      end
      end
  end
  end
end
