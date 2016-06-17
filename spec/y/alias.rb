# alias - class Alias - callable string that replaces value of name

class Alias
  def initialize name, expansion
    @name = name
    @expansion = expansion
  end
  attr_reader :name, :expansion
  def call *args, env:
    arg = args.join(' ')
    statement = @expansion + ' ' + arg
    sexps = Visher.parse! statement
    exc = Executor.new env
    exc.execute! sexps
  end
end

