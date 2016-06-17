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
      fail "recursive call to this alias: #{@name}"
    else
      @@calls << @name
    end
    arg = args.join(' ')
    statement = @expansion + ' ' + arg
    sexps = Visher.parse! statement
    exc = Executor.new env
    result = exc.execute! sexps
    @@calls.pop
    result
  end
end

