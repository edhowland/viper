# bad - class Bad - always fails with false

class Bad
  def call *args, env:, frames:
    env[:err].puts args.join(' ') unless args.empty?
    false
  end
end
