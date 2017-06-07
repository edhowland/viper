# md_block.rb - class MdBlock, MdSpan - containers for Redcarpet parsing
#
# BUGS:
# list_item does not yet work

require 'redcarpet'

class MdBlock
  def initialize text
    @contents = text
  end

  def to_s
    @contents
  end
end

class Para < MdBlock
  #
end

class HRule < MdBlock
  def to_s
    'Horizontal Rule'
  end
end

class BlockHead < MdBlock
  def initialize type, contents
    @type = type
    super contents
  end
  def to_s
    "Heading #{@type} #{@contents}"
  end
end

class BlockQuote < MdBlock
  def initialize quote
    @quote = quote
  end
  attr_reader :quote
  def to_s
    "Blockquote #{@quote}"
  end
end
class Footnote < MdBlock
  #
end

class BlockCode < MdBlock
  def initialize code, lang
    @code = code
    @lang = lang
  end
  attr_reader :code, :lang
  def to_s
    "Code #{@lang}\n#{@code}"
  end
end

class ListType < MdBlock
  def initialize type
    @type = type
  end
  attr_reader :type
  def to_s
    "List #{@type.to_s}"
  end
end

class ListItem < MdBlock
  def initialize type, contents
    @type = type
    @contents = contents
  end
  attr_reader :contents, :type
  def to_s
    @contents
  end
end


# Scan level elements

class MdSpan
  def initialize contents
    @contents = contents
  end

  attr_accessor :contents

  def to_s
    "#{@contents}"
  end
end

class Link < MdSpan
  def initialize link, title, content
    @link = link
    @title = title
    @contents = content
  end
  attr_reader :link, :title, :content
  def to_s
    "Link #{title} #{link} #{content}"
  end
end

class MdRender < Redcarpet::Render::Base
  def initialize
    @storage =  []
    super
  end
  attr_accessor :storage
  def header(text, level)
    storage << BlockHead.new(level, text)
    ''
  end

  # FIXME: Redcarpet gem seems to put contents into Para element, and this text
  # param is empty string
  def block_quote(text)
    storage << BlockQuote.new(text)
    ''
  end
   def footnote_def(content, number)
    storage << Footnote.new(content)
    ''
  end
  def block_code(code, language)
    storage << BlockCode.new(code, language)
    ''
  end
  def hrule
    storage << HRule.new('')
    ''
  end
  def paragraph(text)
    storage << Para.new(text)
    ''
  end
  def list(contents, type)
    storage << ListType.new(type)
    ''
  end
  def list_item(text, type)
    storage << ListItem.new(type, text)
    ''
  end
  
  # scan level elements
  def link(link, title, content) 
    storage << Link.new(link, title, content)
    ''
  end
end


def parse_md storage=[]
  rend = MdRender.new
  rend.storage = storage
    Redcarpet::Markdown.new(rend, :fenced_code_blocks => true, :disable_indented_code_blocks => true, :footnotes =>true)
end
