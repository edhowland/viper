# lazy_argument - class LazyArgument - like Argument, but does not call when
# args are expanded


class LazyArgument < Argument
    def call env:, frames:
      @storage
  end
  def lazy_call env:, frames:
        @storage.call frames:frames, env:env
  end
end
