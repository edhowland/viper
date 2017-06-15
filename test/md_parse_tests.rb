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
  def test_link_has_description
    @parser.render '[description](url)'
    assert_eq @array.first.description, 'description'
  end
  def test_can_parse_blockquote
    @parser.render "> quote line 1\n> line 2\n"
    assert_eq @array.length, 2
    assert_is @array[1], BlockQuote
    #assert_eq @array[1].to_s, ''
    assert_eq @array[1].quote, ''
  end
  def test_hrule_creates_hrule_object
    @parser.render "___\n"
    assert_is @array.first, HRule
  end
end
