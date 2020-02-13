module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i <= length - 1
        yield [self[i]]
        i += 1
      end
    else
      arr = to_a
      while i <= length - 1
        yield [arr[i][0], arr[i][1]]
        i += 1
      end
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i <= length - 1
        yield [self[i], i]
        i += 1
      end
    else
      arr = to_a
      while i <= length - 1
        yield [arr[i], i]
        i += 1
      end
    end
  end

  def my_select
    return to_enum unless block_given?

    if is_a? Array
      arr = []
      my_each { |i| arr << i if yield(i) }
    else
      hashy = {}
      my_each { |i| hashy[i.to_a[0]] = i.to_a[1] if yield i.to_a[0], i.to_a[1] }
    end
    hashy
  end
end
