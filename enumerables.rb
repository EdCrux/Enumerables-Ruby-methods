require 'byebug'

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i <= length - 1
        yield (self[i])
        i += 1
      end
    elsif is_a? Hash
      arr = to_a
      while i <= length - 1
        yield [arr[i][0], arr[i][1]]
        i += 1
      end
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i <= length - 1
        yield [self[i], i]
        i += 1
      end
    elsif is_a? Hash
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
    elsif is_a? Hash
      hashy = {}
      my_each { |i| hashy[i.to_a[0]] = i.to_a[1] if yield i.to_a[0], i.to_a[1] }
    end
    hashy
  end

  def my_all?(data = nil)
    return my_all?(data) if block_given? && !data.nil?

    if block_given?
      my_each { |i| return false unless yield(i) }
      true
    elsif data.nil?
      my_each { |i| i }
    elsif data.is_a? Regexp
      my_each { |i| return false unless i.to_s.match(data) }
    elsif data.is_a? Class
      my_each { |i| return false unless i.is_a? data }
    else
      my_each { |i| return false unless i == data }
    end
    true
  end

  def my_any?(data = nil)
    return my_any?(data) if block_given? && !data.nil?

    if block_given?
      my_each { |item| return true if yield item }
      false
    elsif data.is_a? Regexp
      my_each { |i| return true if i.to_s.match(data) }
    elsif data.is_a? Class
      my_each { |i| return true if i.is_a? data }
    else
      my_each { |i| return true if i == data }
    end
    false
  end

  def my_none?(data = nil)
    return my_none?(data) if block_given? && !data.nil?

    if block_given?
      my_all? { |i| return false if yield(i) }
      true
    elsif data.is_a? Regexp
      my_all? { |i| return false if i.to_s.match(data) }
    elsif data.is_a? Class
      my_all? { |i| return false if i.is_a? data }
    end
    true
  end

  def my_count(data = nil)
    return my_count(data) if block_given? && !data.nil?

    counter = 0
    if block_given?
      my_each { |i| return counter += 1 if yield(i) }
    elsif !data.nil?
      my_each { |i| return counter += 1 if i == data }
    end
  end

  def my_map
    return to_enum(:my_map) if !block_given? && proc.nil?

    map_array = []
    my_each { |item| map_array << yield(item) }
    map_array
  end

  def my_inject(*initial)
    arr = to_a
    memo = arr[0]
    if initial[1].nil? && block_given?
      memo = initial[0]
    elsif initial[1].nil? && !block_given?
      sym = initial[0]
      memo = 0
    else
      memo = initial[0]
      sym = initial[1]
    end
    arr.my_each do |item|
      if sym
        memo = memo.send sym, item
      else
        memo = yield(memo, item)
      end
    end
    memo
  end
end
