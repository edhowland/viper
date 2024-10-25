# drop_while.rb - adds drop_while functionality to enumerables like arrays

module Dropper
  def drop_while(&blk)
    count = 0
    self.each do |it|
      if blk.call(it)
        count += 1
      else
        break
      end
    end

    self.drop(count)
  end
end