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
