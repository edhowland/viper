# null_facade - class NullFacade - default thing that does nothing

class NullFacade
  def open(_path, _mode)
    StringIO.new
  end
end
