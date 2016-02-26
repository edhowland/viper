# command_block_expected.rb - exception CommandBlockExpected
#  CommandBlockExpected raise when block was expected for command string, but was not given
class CommandBlockExpected < RuntimeError
  def initialize
    super 'Block in executing command string expected, but was not given'
  end
end
