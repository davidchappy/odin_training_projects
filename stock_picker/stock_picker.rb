def stock_picker(array)
  buying_schedule = []
  profit = 0

  array.each_with_index do |price, index|
    high = array[index..-1].max
    opportunity = high - price
    high_index = array.index(high)

    if opportunity > profit
      profit = opportunity
      buying_schedule = [index, high_index]
    end  
  end

  p profit
  p buying_schedule
end

stock_picker([17,3,6,9,15,8,6,1,10])
# stock_picker([1,17,3,9,15,8,6,10,6,1])


# pseudo-code #
## 1. Find highs and lows within array and return their index values in a new array.
## 2. Buy before selling
# 3. Edge cases
