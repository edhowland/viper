# expr - class Expr - command expr - prints result of expression
# Usage:
# expr 1 + 3  => 4
# expr 5 -2 => 3

class Expr < BaseCommand
  def call *args, env:, frames:
    if args.length == 3
      a1, op, a2 = args
      a1 = a1.to_i; a2 = a2.to_i
      op = op.to_sym
      if a1.respond_to? op
        env[:out].puts a1.send op, a2
        true
      else
        env[:err].puts "expr: argument 1 #{a1} cannot do : #{op}"
        false
      end
    else
      arg_error 3, env:env
      false
    end
  end
end