# buffer test_cmdlet.rb # tests for commandlets

require_relative 'test_helper'


class TestCmdlet < MiniTest::Test
  def test_on_args_w_bool_arg
    assert_eq ['-f'], on_args('f')
  end
  def test_on_args_w_value_argument
    assert_eq ['-y value', String], on_args('y:')
  end
  def test_opt_parse_w_one_argument
    o=optparse_from('f')
    h = {}
    o.parse!(['-f', 'a0'], into: h)
    assert h[:f]
  end
  def test_optparse_from_w_value_argument
    o = optparse_from('y:')
    h = {}
    o.parse!(['-y', 'no'], into: h)
    assert_eq 'no', h[:y]
  end
  def test_optparse_from_w_2_bool_flags
    o = optparse_from 'x,b'
    h = {}
    o.parse!(['-b', '-x', 'a1', 'a2'], into: h)
    assert h[:x]
    assert h[:b]
  end
end