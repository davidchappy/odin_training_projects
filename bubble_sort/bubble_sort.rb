def bubble_sort(list)
  iterations = list.size - 1
  next_item_index = 0

  iterations.times do 
    list.each_with_index do |list_item, index|
      unless list_item == list.last 
        next_item_index = index + 1
      end
      if list_item > list[next_item_index]
        list[index], list[next_item_index] = list[next_item_index], list[index] # make the swap
      end
    end
    list 
  end

  p list
end

bubble_sort([10,9,8,7,6,5,4,3,2,1])


def bubble_sort_by(list)
  iterations = list.size - 1
  next_item_index = 0

  iterations.times do 
    list.each_with_index do |list_item, index|
      unless index == list.size - 1 
        next_item_index = index + 1
      end
      if yield(list_item, list[next_item_index]) > 0
        list[index], list[next_item_index] = list[next_item_index], list[index] # make the swap
      end
    end
    list 
  end

  p list
end

bubble_sort_by(["hi","hello","hey"]) do |left, right|
  left.length - right.length
end
