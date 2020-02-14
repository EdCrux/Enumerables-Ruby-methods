require_relative "enumerables"

public
def my_each
    return to_enum unless block_given?

    i = 0
    if is_a? Array
      while i <= length - 1
        yield self[i]
        i += 1
      end
    elsif is_a? Hash
      arr = to_a
      while i <= length - 1
        yield [arr[i][0], arr[i][1]]
        i += 1
      end
    end
  end

def my_all? (pattern = nil)
    return my_all?(pattern) if block_given? && !pattern.nil?
    if block_given?
        my_each { |i| yield(i) ? true : false}
    else
        case pattern.class
        when true 
            my_each { |i| i} 
        when Regexp 
            my_each { |i| return false unless i =~ pattern }
        when Class 
            my_each { |i| return false unless i.class == pattern }
        else 
            my_each { |i| return false unless i == pattern  }
        end
    end 

end

#Assertion                                           Return
p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
