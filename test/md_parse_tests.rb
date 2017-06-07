# md_parse.rb - tests for MdBlock, MdSpan, etc

require_relative 'test_helper'
#require_relative '../lib/api/md_block'

class HuntTests < BaseSpike
  def set_up
    @array = []
        @parser = parse_md(@array)
  end
  def test_can_parse_empty_string
    @parser.render ''
  end
  def test_parse_md_returns_redcarpet_markdown
    assert_is @parser, Redcarpet::Markdown
  end
  def test_can_parse_head
    @parser.render "# head 1\n"
    assert_eq @array.length, 1
    assert_is @array.first, BlockHead
  end
  def test_can_parse_para
    @parser.render "This is some text\n"
    assert_is @array.first, Para
  end
  def test_can_parse_code_blocks
    @parser.render "```\nthis is code\n```\n"
    assert_is @array.first, BlockCode
  end
  def test_can_parse_ul_lists
    @parser.render "- item 1\n- item 2\n"
    assert_eq @array.length, 3
    assert_eq @array.map(&:class), [ListItem, ListItem, ListType]
  end
  def test_can_parse_link
    @parser.render '[https://github.com/edhowland/viper_ruby](https://github.com/edhowland/viper_ruby)'
    assert_eq @array.length, 2
    assert_is @array[0], Link
    assert_is @array[1], Para
  end
end
