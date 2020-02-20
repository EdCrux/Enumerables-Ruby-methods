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

def my_all?(data = nil)
  return my_all?(data) if block_given? && !data.nil?
  arr = to_a
  return false if arr.length == 1 && arr[0] == nil
  if block_given?
    my_each { |i|  false unless yield(i) }
    true
  elsif data.nil?
    index = 0
    while index <= arr.length-1
      return false unless arr[index].class == arr[index + 1].class
      index += 1  
    end
  elsif data.is_a? Regexp
    my_each { |i|  false unless i.to_s.match(data) }
  elsif data.is_a? Class
    my_each { |i|  false unless i.is_a? data }
  else
    my_each { |i|  false unless i == data }
  end
  true
end

def my_none?(data = nil)
  return my_none?(data) if block_given? && !data.nil?
  return true if self.empty?
  if block_given?
    my_all? { |item| yield(item) ? false : true }
  elsif data.is_a? Regexp
    my_all? { |item| item.to_s.match(data) ?  false : true }
  elsif data.is_a? Class
    my_all? { |item| item.class == data ? false : true }
  elsif data.nil?
     my_all?(data) ? false : true 
  end
end

%w{ant bear cat}.none? { |word| word.length == 5 } #=> true
%w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
%w{ant bear cat}.none?(/d/)                        #=> true
[1, 3.14, 42].none?(Float)                         #=> false
[].none?                                           #=> true
[nil].none?                                        #=> true
[nil, false].none?                                 #=> true
p [nil, false, true].my_all?                           #=> false