# bad - class Bad - always fails with false

class Bad
  def call *args, env:
    false
  end
end
