class LinkedList

  attr_reader :list

  class Node
    attr_accessor :value, :next_node

    def initialize(value=nil,next_node=nil)
      @value = value
      @next_node = next_node
    end
  end

  def initialize(list=[])
    @list = []
    unless list.empty?
      list.each do |item|
        append(item)
      end
    end
  end

  def append(value)
    @list << Node.new(value)
    set_links
  end

  def prepend(value)
    @list.unshift(Node.new(value,@list[0]))
  end

  def size
    @list.length
  end

  def head
    @list.first
  end

  def tail
    @list.last
  end

  def at(index)
    @list[index]
  end

  def pop
    @list.delete_at(-1)
    set_links
  end

  def contains?(query)
    @list.each do |node|
      return true if node.value == query
    end
    return false 
  end

  def find(data)
    @list.each_with_index do |node, index|
      # this allows for partial matching; for exact matching: if node.value == data
      if node.value.to_s.downcase.include?(data.to_s.downcase)
        return index
      end 
    end
    return nil
  end

  def to_s
    output = ""
    @list.each do |node|
      output << "( " + node.value.to_s + " )" + " -> "
      if node == @list.last
        output << "nil"
      end
    end
    output
  end

  def insert_at(ins_point, data)
    @list.insert(ins_point, Node.new(data))
    set_links
  end

  def remove_at(index)
    @list.delete_at(index)
    set_links
  end

  def set_links
    @list.each_with_index do |node,index|
      unless node == @list.last || @list.size < 2
        node.next_node = @list[index+1]
      else
        node.next_node = nil
      end
    end
  end

end

list = LinkedList.new([1,3])

list.append(8)
list.prepend(5)
# puts list.size
# p list.head
# p list.tail
# p list.at(2)
# p list.pop
# puts list.contains?(2)
# p list.find(5)
# list.insert_at(2,13)
# list.remove_at(3)
puts list.to_s

# list.list.each {|node| p node }