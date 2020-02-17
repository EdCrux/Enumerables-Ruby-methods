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
      my_each { |item| return false unless item.is_a? data }
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
end
