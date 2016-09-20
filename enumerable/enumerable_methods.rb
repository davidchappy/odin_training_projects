module Enumerable
  
  def my_each
    i = 0
    while i <= self.length - 1
      if self.is_a?(Hash)
        current_key = self.keys[i]
        yield [current_key, self[current_key]]
      else
        yield self[i]
      end
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    self.my_each do |item|
      yield(item, i)
      i += 1
    end
  end

  def my_select
    case
    when self.is_a?(Hash)
      modified_hash = {}
      self.my_each do |item|
        modified_hash[item.first] = item.last if yield(item)
      end
      selected = modified_hash
    else 
      modified_array = []
      self.to_a.my_each do |item|
        modified_array.push(item) if yield(item)
      end
      selected = modified_array
    end
    selected
  end

  def my_all?
    if block_given?
      self.my_each do |item|
        return false unless yield(item)
      end
    end
    true
  end

  def my_any?
    if block_given?
      self.my_each { |item| return true if yield(item) }
      return false
    end
    return false if self.nil?
    true
  end

  def my_none?
    if block_given?
      self.my_each { |item| return false if yield(item) }
      return true
    end
    true
  end

  def my_count(target=nil)
    count = 0
    self.my_each do |item|
      if block_given? 
        count += 1 if yield(item) 
      elsif target != nil
        count += 1 if item == target
      else
        count += 1
      end
    end
    count
  end

  def my_map(proc=nil)
    self.my_each_with_index do |item, index|
      if proc != nil && proc.is_a?(Proc)
        self[index] = proc.call(item)
      else
        self.to_a[index] = yield(item)
      end
    end
    self
  end

  def my_inject(initial=nil)
    memo = initial == nil ? self.first : initial
    self.unshift(initial) unless initial == nil
    i = 1
    while i < self.length
      memo = yield(memo, self[i])
      i += 1
    end
    memo
  end

end

def multiply_els(elements)
  elements.inject { |memo, obj| memo * obj }
end

# test data
a = [10,20,30]
h = {"one" => 1, "two" => 2, "three" => 3}


# each test
# h.each_with_index do |key, value|
#   p key
#   p value
# end
# puts "-----"
# h.my_each_with_index do |key, value|
#   p key
#   p value
# end

# select test
# new_array = a.select { |n| n > 1 } 
# p new_array
# new_hash = h.select { |k, v| v > 1 } 
# p new_hash
# puts "-----"
# new_array = a.my_select { |n| n > 1 } 
# p new_array
# new_hash = h.my_select { |k, v| v > 1 } 
# p new_hash

# all/any/none test
# p a.my_all?{ |n| n > 1 }
# p a.my_any?{ |n| n > 2 }
# p a.my_none?{ |n| n > 3 }

# count test
# p a.my_count{ |n| n < 2}

# map test
# p a.my_map{|n| n * 2 }
# p = Proc.new {|n| n * 2 }
# p a.my_map(p)

# inject test
# p a.inject{ |m, n| m * n }
# p a.my_inject{ |m, n| m * n }
# p a.inject(2){ |m, n| m * n }
# p a.my_inject(2){ |m, n| m * n }

# multiply_els
# p multiply_els(a)
