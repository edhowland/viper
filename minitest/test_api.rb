# api_tests.rb - tests for  api/*.rb

require_relative 'test_helper'


class APITests < MiniTest::Test
  def test_path_from_start_elements_returns
    path_from_start_elements ''
  end
  def test_path_from_with_empty_full_path_returns_absolute
    assert_eq '/v/bin', path_from_start_elements('', ['v', 'bin'])
  end
  def test_path_from_non_empty_returns_relative_path
    assert_eq 'bin', path_from_start_elements('v', ['bin'])
  end
  def test_empty_start_and_elements_returns_slash
    assert_eq '/', path_from_start_elements('')
  end
  def test_relative_dot_dot_returns_dot_dot
    assert_eq '..', path_from_start_elements('v', ['..'])
  end
end


class ArrayExtenderTests < MiniTest::Test
  def setup
    @obj = "line1\nline2\nline3\n".chars
    @obj.extend ArrayExtender
  end
  def test_wired_ok
  end
  def test_lines
    l = @obj.lines
    assert_not_empty l
  end
  def test_regexify_returns_regexp_class
    result = regexify 'a'
    assert_is result, Regexp
  end
  def test_regexify_w_pattern_matches_input
    result = regexify 'cat'
    assert(!!'cat'.match(result))
  end
  def test_rangify
    r = rangify '2..4'
    assert_is r, Range
    assert_eq r, 2..4
  end
  def test_rangify_returns_nil_if_no_range_string_given
    result = rangify '12'
    assert_nil result
  end
  def test_head_or_all_single_element_returns_that_element
    result = head_or_all [55]
    assert_eq result, 55
  end
  def test_head_or_all_returns_entire_input_if_more_than_element
    input = [0,1,2,3]
        result = head_or_all input
        assert_eq result, input
  end
  def test_default_path_returns_fqn_imput
    # If default_path(/v/foo/bar', /v/foo/bar') => '/v/foo/bar'
    assert_eq '/v/foo/bar', default_path('/v/foo/bar', default: '/v/foo/bar')
  end
  def test_default_path_w_just_name_returns_appended_fqn
    # default_path 'baz', default: '/v/cmdlet/misc' => /v/cmdlet/misc/baz
    assert_eq '/v/cmdlet/misc/baz', default_path('baz', default: '/v/cmdlet/misc')
  end
  def test_int_or_error
    assert_eq 0, int_or_error(0)
  end
  def test_int_or_error_with_string_is_0
    assert_eq 255, int_or_error('foo')
  end
  def test_int_or_error_returns_0_when_string_is_0_
    assert_eq 0, int_or_error('0')
  end
  def test_int_or_error_returns_int_value_of_string_number
    assert_eq 45, int_or_error('45')
  end
  def test_int_or_error_returns_0_when_blank_string
    assert_eq 255, int_or_error('')
  end
end
