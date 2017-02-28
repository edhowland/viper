# lazy_argument - class LazyArgument - like Argument, but does not call when
# args are expanded

class LazyArgument < Argument
  def call env:, frames:
    @storage
  end
end
