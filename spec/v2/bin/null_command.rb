# null_command - class NullCommand - for when no command in Statement


class NullCommand
  def call frames:
    frames.pop_and_store
  end
end
