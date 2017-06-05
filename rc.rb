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
  #
end

class MdRender < Redcarpet::Render::Base
  def initialize
    @storage =  []
    super
  end
  attr_accessor :storage
  def header(text, level)
    storage << Head.new( "Heading level #{level} #{text}")
    ''
  end
  def paragraph(text)
    storage << Para.new(text)
    ''
  end
  def list(contents, type)
    #    "List #{type}\n"
    nil
  end
  def list_item(text, type)
    "bullet #{text}\n"
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
  p = start
  text = readme
  arr = []
  p.render text
end

binding.pry
