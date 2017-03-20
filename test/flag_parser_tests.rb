# flag_parser_tests.rb - tests for FlagParser

require_relative 'test_helper'

class FlagParserTests < BaseSpike
  def set_up
    @parser = FlagParser.new
  end
  def test_raises_argument_error
    assert_raises ArgumentError do
      @parser.arg_type '', '', Hash
    end
  end
  def test_sets_lambda_to_be_called
    @parser.on('-e') do
      #
    end
    assert_is @parser.flags['-e'], Proc
  end
  def test_parse_method_w_empty_does_nothing
    @parser.parse []
  end
  def test_w_single_arg_sets_flag
    flag = false
    @parser.on('-e') do
      flag = true
    end
    @parser.parse ['-e']
    assert flag
  end
end