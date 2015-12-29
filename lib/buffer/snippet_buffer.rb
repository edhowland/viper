# snippet_buffer.rb - class SnippetBuffer

class SnippetBuffer < Buffer
  include Recordable

  def save
    $snippets[@name] = @commands
  end

  def clear
    super
    @name = ''
    @commands = []
  end
end

