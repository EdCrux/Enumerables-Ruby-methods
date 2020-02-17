require_relative "enumerables"
require 'byebug'

public



p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
p %w[ant bear cat].any?(/d/)                        #=> false
p [nil, true, 99].any?(Integer)                     #=> true
p [nil, true, 99].any?                              #=> true
p [].any?                                           #=> false

