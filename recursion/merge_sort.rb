def merge_sort(array)
  return array if array.length == 1
  left,right = array.each_slice( (array.size/2.0).round ).to_a # http://heyrod.com/snippets/split-ruby-array-in-half.html
  left = merge_sort(left) 
  right = merge_sort(right)
  array.each_index do |i|
    unless right.empty? || left.empty?
      array[i] = right[0] <= left[0] ? right.shift : left.shift
    else 
      array[i] = right.empty? ? left.shift : right.shift
    end
  end
  array
end

p merge_sort([1,3,12,5,4,7,3,10,2,100,302,-1,4])
