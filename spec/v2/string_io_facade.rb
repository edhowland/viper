# string_io_facade - class StringIOFacade - open method for StringIO


class StringIOFacade
  def initialize stringio
    @io = stringio
  end
  def open mode
    # assume write for now: mode = 'w'
    @io.reopen('', 'w')
  end
end
