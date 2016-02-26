# non_recordable.rb - module NonRecordable

# NonRecordable module is included in Buffer subclasses which can not be recorded via record method. These buffers cannot be undone or redone.
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
