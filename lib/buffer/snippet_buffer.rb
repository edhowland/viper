# snippet_buffer.rb - class SnippetBuffer

class SnippetBuffer < Buffer
  include Recordable

  def save
    $snippets[@name] = @commands
  end

  def clear
    @name = ''
    @commands = []
  end
end

