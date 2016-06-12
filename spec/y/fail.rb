# fail - class Fail - always fails with false

class Fail
  def cal *args, env:
    false
  end
end
