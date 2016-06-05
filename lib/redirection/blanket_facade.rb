# blanket_facade - class BlanketFacade - wraps unknown objects for redirection

class BlanketFacade
  def initialize item
    @item = item
  end
  def read
    if @item.class.method_defined? :to_s
      @item.to_s
    else
      @item.inspect
    end
  end
  def write contents
    case @item
    when String
      @item[0, @item.length] = contents
    else
      fail "Do not know how to write to #{@item.class.name}"
    end
  end
end

