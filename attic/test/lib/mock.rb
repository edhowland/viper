# mock.rb - class Mock -  object that responds to expectations and verifies
# them

class Mock
  def initialize
    @expects = []
    @actuals = []
  end

  attr_reader :expects, :actuals
  alias_method :old_respond_to, :respond_to?
  def respond_to? name
    @expects.map {|e| e[0] }.member?(name) || old_respond_to(name)
  end
  def wont name
        instance_eval "undef :#{name}" if self.respond_to? name
  end
  def expect name, *args, **keywords
    wont name
    @expects << [name, args, keywords]
  end
  def verify!
    assert @expects == @actuals, 'Mock expectation error' + "\nExpected #{@expects.inspect}\nGot: #{@actuals.inspect}\n"
    @actuals == @expects
  end
  def method_missing name, *args, **keywords
    @actuals << [name, args, keywords]
  end
end
