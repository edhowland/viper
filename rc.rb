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

class MdRender < Redcarpet::Render::Base
  def header(text, level)
    "Heading level #{level} #{text}\n"
  end
  def paragraph(text)
    text + "\n"
  end
  def list(contents, type)
    "List #{type}\n"
  end
  def list_item(text, type)
    "bullet #{text}\n"
  end
end

def start
  Redcarpet::Markdown.new(MdRender.new)
end


def readme
  File.read('r.md')
end

binding.pry
