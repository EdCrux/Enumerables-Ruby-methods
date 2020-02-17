require_relative "enumerables"
require 'byebug'

public





p %w{ant bear cat}.none? { |word| word.length == 5 } #=> true
p %w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
p %w{ant bear cat}.none?(/d/)                        #=> true
p [1, 3.14, 42].none?(Float)                         #=> false
p [].none?                                           #=> true
p [nil].none?                                        #=> true
p [nil, false].none?                                 #=> true
p [nil, false, true].none?                           #=> false

