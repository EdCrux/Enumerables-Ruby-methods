require_relative "enumerables"
require 'byebug'


public

def my_inject(*initial)
    arr = to_a
    if initial[0].nil?
        memo = arr[0]
    elsif initial[1].nil? && !block_given?
        sym  = initial[0]
        memo = 0
    elsif initial[1].nil? && block_given?
        memo = initial[0]
    else
        memo = initial[0]
        sym  = initial[1]
    end 
    arr.each do |item| 
        if sym
           memo = memo.send(sym, item)
        else 
           memo = yield(memo,item)
        end
    end
    memo
end

#Sum some numbers
p (5..10).my_inject(:+)
#                             #=> 45 ✔
# # Multiply some numbers
 p (5..10).my_inject(1, :*)                          #=> 151200 ✔ 

# # Same using a block and inject
 p (5..100).my_inject { |sum, n| sum + n }            #=> 45 ✔

# # Same using a block
 p (5..10).my_inject(1) { |product, n| product * n } #=> 151200 ✔ 

# # find the longest word
 longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
 end
# #longest                                        #=> "sheep"
 p longest