def fibs(n)
  x,y = 0,1
  n.times {|i| x, y = y, x + y } 
  y
end

def fibs_rec(n)
  return n > 0 && n < 3 ? n : fibs_rec(n-1) + fibs_rec(n-2)
end

p fibs(10)
p fibs_rec(10)