# command_block_expected.rb - exception CommandBlockExpected

class CommandBlockExpected < RuntimeError

    def initialize 
    super 'Block in executing command string expected, but was not given'
  end
end

