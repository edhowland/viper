# rc.rb - test harnes to load redcarpet gem for experimenting
# Usage: start w/ pry -r ./rc.rb
# Example interaction:
# p=start  # gets a markdown parser
# text = readme  # reads the text fromfile: r.md
# ## which is short version of README.md
#
# p.render(text)
# will return a string with parsed elements

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

class Head < MdBlock
  def initialize type, contents
    @type = type
    super contents
  end
  def to_s
    "Heading #{@type} #{@contents}"
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

class MdRender < Redcarpet::Render::Base
  def initialize
    @storage =  []
    super
  end
  attr_accessor :storage
  def header(text, level)
    storage << Head.new(level, text)
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
end

def start storage=[]
  rend = MdRender.new
  rend.storage = storage
    Redcarpet::Markdown.new(rend)
end


def readme
  File.read('r.md')
end

def doit
  arr = []
  p = start arr
  text = readme
  p.render text
  arr
end



# gets the class of each item in arr
def blocks arr
  arr.map(&:class)
end
binding.pry
