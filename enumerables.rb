require 'byebug'

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

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
    return to_enum(:my_each_with_index) unless block_given?

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
    return to_enum(:my_select) unless block_given?

    if is_a? Hash
      hashy = {}
      my_each { |item| hashy[item.to_a[0]] = item.to_a[1] if yield i.to_a[0], i.to_a[1] }
    else
      arr = []
      to_a.my_each { |item| arr << item if yield(item) }
      arr
    end
  end

  def my_all?(data = nil)
    return my_none?(data) if block_given? && !data.nil?

    arr = to_a
    return true if arr.empty?

    if block_given?
      to_a.my_each { |item| return false unless yield(item) }
    elsif data.nil? && !block_given?
      to_a.my_each { |item| return false unless item }
    elsif data.is_a? Class
      to_a.my_each { |item| return false unless item.is_a? data }
    elsif data.is_a? Regexp
      to_a.my_each { |item| return false unless item.to_s.match(data) }
    end
    true
  end

  def my_any?(data = nil)
    return my_any?(data) if block_given? && !data.nil?

    if block_given?
      to_a.my_each { |item| return true if yield item }
      false
    elsif data.is_a? Regexp
      to_a.my_each { |item| return true if item.to_s.match(data) }
    elsif data.is_a? Class
      to_a.my_each { |item| return true if item.is_a? data }
    else
      to_a.my_each { |item| return true if item == data }
    end
    false
  end

  def my_none?(data = nil)
    return my_none?(data) if block_given? && !data.nil?

    if block_given?
      to_a.my_each { |item| return false if yield(item) }
    elsif data.is_a? Regexp
      to_a.my_each { |item| return false if item.to_s.match(data) }
    elsif data.is_a? Class
      to_a.my_each { |item| return false if item.is_a? data }
    elsif data.nil?
      to_a.my_each { |item| return false if item }
    end
    true
  end

  def my_count(*data)
    arr = to_a
    return 0 if arr.empty?

    counter = 0
    if data[0]
      arr.my_each { |item| counter += 1 if item == data[0] }
    elsif block_given?
      arr.my_each { |item| counter += 1 if yield(item) }
    else
      arr.my_each { |item| counter += 1 if item }
    end
    counter
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    map_array = []
    to_a.my_each { |item| map_array << yield(item) }
    map_array
  end

  def my_inject(*initial)
    arr = to_a
    return raise ArgumentError, 'Given arguments 0, expected at least 1' if initial.empty? && !block_given?

    memo = initial.length == 2 && arr.respond_to?(initial[1]) || initial.length == 1 && block_given? ? initial[0] : arr.shift
    sym = if initial.length == 2
            initial[1]
          elsif !block_given? && initial.length == 1 && arr.respond_to?(initial[0])
            initial[0]
          else
            false
          end
    arr.my_each { |item| memo = sym ? memo.send(sym, item) : yield(memo, item) }
    memo
  end
end
