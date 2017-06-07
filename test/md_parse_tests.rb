# md_parse.rb - tests for MdBlock, MdSpan, etc

require_relative 'test_helper'
require_relative '../lib/api/md_block'

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
end