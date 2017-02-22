# alias - class Alias - callable string that replaces value of name

class Alias
  @@calls = []
  def initialize name, expansion
    @name = name
    @expansion = expansion
  end
  attr_reader :name, :expansion
  def call *args, env:
    if @@calls.member? @name
      env[:err].puts "recursive call to this alias: #{@name}"
      false
    else
      @@calls << @name
      arg = args.join(' ')
      statement = @expansion + ' ' + arg
      sexps = Visher.parse! statement
      exc = Executor.new env
      result = exc.execute! sexps
      @@calls.pop
      result
    end
  end
end

