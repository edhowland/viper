# tr.rb - class Tr - commandtr pat sub - substitutes pattern for sub

class Tr < BaseCommand
  def normalize_nl string
    string.gsub('\n', "\n")
  end
  def call *args, env:, frames:
    super do |*a|
      pat, sub = a
      pat = normalize_nl(pat)
      #binding.pry
      @out.write(@in.read.tr(pat, sub))
      true
    end
  end
end