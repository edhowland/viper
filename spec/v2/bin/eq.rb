# eq - class Eq - command eq tests arg1 and arg2 for equality

class Eq
  def call *args, env:, frames:
    unless args.length == 2
      env[:err].puts "eq: must supply 2 args. got: #{args.length}. #{args.inspect}"
      false
    else
      args[0] == args[1]
    end
  end
end
