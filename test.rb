require_relative "enumerables"

series = {
    friends: 2,
    malcom: 5,
    sabrina: 1
  }

x = [2,3,5,8,7]

x.my_each_index{ |a,i| puts "Index:#{i}" }