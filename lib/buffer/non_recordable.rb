# non_recordable.rb - module NonRecordable

module NonRecordable
  def can_undo?
    false
  end

  def can_redo?
    false
  end

  def record(method, *args)
    # nop
  end

  def undo
    # nop
  end

  def redo
    # nop
  end
end
