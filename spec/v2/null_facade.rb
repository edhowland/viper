# null_facade - class NullFacade - default thing that does nothing


class NullFacade
  def open mode
    StringIO.new
  end
end
