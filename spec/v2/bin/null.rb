# null.rb - class Null - for when no command in Statement


class Null
  def call frames:
    frames.pop_and_store
  end
end
