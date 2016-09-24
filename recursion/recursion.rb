# def append( ary, n )
#   return ary if n < 0
#   ary.push(n)
#   append( ary, n - 1) 
# end

# p append([], 50)


def reverse_append(ary, n)
  return ary if n < 0
  ary.unshift(n) 
  reverse_append(ary, n - 1)
end

# reverse_append [], -1
p reverse_append [], 0
p reverse_append [], 1
p reverse_append [], 2