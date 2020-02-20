#require_relative "enumerables"
require 'byebug'

public

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

proc { |x| x }
my_each











def my_all?(data = nil)
  return my_all?(data) if block_given? && !data.nil?
  if block_given?
    my_each { |i| return false unless yield(i) }
    true
  elsif data.nil?
    arr = to_a
    index = 0
    while index <= arr.length-1
      return false unless arr[index].class == arr[index + 1].class
      index += 1  
    end
  elsif data.is_a? Regexp
    my_each { |i| return false unless i.to_s.match(data) }
  elsif data.is_a? Class
    my_each { |i| return false unless i.is_a? data }
  else
    my_each { |i| return false unless i == data }
  end
  true
end

def my_none?(data = nil)
  return my_none?(data) if block_given? && !data.nil?

  if block_given?
    my_all? { |item| yield(item) ? false : true }
  elsif data.is_a? Regexp
    my_all? { |i| return false if i.to_s.match(data) }
  elsif data.is_a? Class
    my_all? { |i| return false if i.is_a? data }
  elsif data.nil?
    my_all?(data)
  end
end

p %w{ant bear cat}.my_all? { |word| word.length === 5 } #=> false
p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
p %w{ant bear cat}.my_none?(/d/)                        #=> true
p [1, 3.14, 42].my_none?(Float)                         #=> false
p [].my_none?                                           #=> true
p [nil].my_none?                                        #=> true
p [nil, false].my_none?                                 #=> true
p [nil, false, true].my_none?                           #=> false