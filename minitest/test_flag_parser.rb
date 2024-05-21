# flag_parser_tests.rb - tests for FlagParser

require_relative 'test_helper'

class FlagParserTests < MiniTest::Test
  def setup
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
  def test_w_string_param_sets_value
    str = ''
    @parser.on('-e') do |string|
      str = string
    end
    @parser.parse ['-e', 'dummy']
    assert_equal str, 'dummy'
  end
  def test_parse_exclaim_returns_non_arg_values
    bool = false
    @parser.on('-e') { bool = true }
    my_file = ''
    @parser.on('-f') {|file| my_file = file }
    result = @parser.parse! ['-f', 'ruby.rb', 'no_arg', '-e', 'nuther']
    assert bool
    assert_equal my_file, 'ruby.rb'
    assert_equal result, ['no_arg', 'nuther']
  end
end

class FlagHashTests < MiniTest::Test
  def setup
    @orig_hash = {'-e' => false, '-f' => nil}
        @parser = FlagHash.new flag_hash: @orig_hash
  end
  def test_parse_returns_hash_w_empty_returns_original_hash
    result = @parser.parse []
    assert_equal result, @orig_hash
  end
  def test_w_dash_e_returns_true_value_in_hash
    result = @parser.parse ['-e']
    assert result['-e']
  end
  def test_is_boolean_w_true
    assert @parser.is_boolean?(true)
  end
  def test_is_boolean_w_false
    assert @parser.is_boolean?(false)
  end
  def test_is_boolean_w_nil_is_false
    assert_false @parser.is_boolean?(nil)
  end
  def test_w_param_returns_hash_value_is_param
    result = @parser.parse ['-f', 'file']
    assert_equal result['-f'], 'file'
  end
  def test_multiple_types_of_flags_params
    result = @parser.parse ['-e', '-f', 'string', 'dummy']
    assert result['-e']
    assert_equal result['-f'], 'string'
  end
  def test_parse_exclaim_returns_flags_and_remaining_args
    flags, args = @parser.parse! ['-e', '-f', 'filename', 'arg1', 'arg2']
    assert_not_nil flags
    assert_not_nil args
    assert_is flags, Hash
    assert_is args, Array
  end
  def test_after_parse_parsed_hash_resuumes
  assert_false @parser.parsed_hash['-e']
    @parser.parse! ['-e']
    assert @parser.parsed_hash['-e']
    @parser.parse!
    assert_false @parser.parsed_hash['-e']
  end
end