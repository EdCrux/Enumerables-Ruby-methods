module Enumerable
  public

  def my_each
    return self.to_enum unless block_given?

    self.length.times { |i| yield self[i] } if self.is_a? Array
    if self.is_a? Hash
      i = 0
      while i <= self.length - 1 do
        yield [self.keys[i], self.values[i]]
        i += 1
      end
    end
  end

  def my_each_index
    return self.to_enum unless block_given?

    i = 0
    if self.is_a? Array
      while i <= self.length - 1 do
        yield [self[i], i]
        i += 1
      end
    end
    if self.is_a? Hash
      while i <= self.length - 1 do
        yield [self.keys[i], self.values[i], i]
        i += 1
      end
    end
  end
end
