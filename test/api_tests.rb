# api_tests.rb - tests for  api/*.rb

require_relative 'test_helper'

class APITests < BaseSpike
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


class ArrayExtenderTests < BaseSpike
  def set_up
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
end
