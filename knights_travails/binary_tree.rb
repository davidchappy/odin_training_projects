  class Node
    attr_reader :value
    attr_accessor :parent, :left, :right

    def self.build_tree(array)
      # array.sort!

      @@root = self.new( array.delete_at( (array.size/2.0 - 1).round ) )
      array.each do |v|
        @@root.insert v
      end
      @@root
    end

    def initialize(value=0, parent=nil)
      @value = value
      @parent = parent
      @left ||= nil
      @right ||= nil
    end

    def inspect
      if self == @@root
        puts "Root: #{value}"
      else
        puts "Node: #{value}"
      end
      puts "#{value}'s parent: #{parent.value}" if parent
      if left
        puts "#{value}'s left: #{left.value.inspect}" 
        left.inspect
      end
      if right
        puts "#{value}'s right: #{right.value.inspect}"  
        right.inspect
      end
    end

    def bfs(v)
      queue = []
      queue << @@root

      until queue.empty?

        query = queue.delete_at(0)

        return query if query.value == v

        queue << query.left unless query.left.nil?
        queue << query.right unless query.right.nil?

      end

      return "Not found"
    end

    def dfs(v)
      stack = []
      stack << @@root

      until stack.empty?

        query = stack.pop

        return query if query.value == v

        stack << query.right unless query.right.nil? 
        stack << query.left unless query.left.nil? 

      end

      return "Not Found"

    end

    def dfs_rec(v, node=@@root)

      return nil if node.nil?
      return node if node.value == v
      left_node = dfs_rec(v, node.left)
      return left_node unless left_node.nil?
      right_node = dfs_rec(v, node.right)
      return right_node unless right_node.nil?

    end

    def insert(v)
      case v <=> self.value
      when 1 then insert_right(v)
      when -1 then insert_left(v)
      when 0 then false
      end 
    end

    def insert_left(v)
      if left
        left.insert(v)
      else
        self.left = Node.new(v, self)
      end
    end

    def insert_right(v)
      if right
        right.insert(v)
      else
        self.right = Node.new(v, self)
      end
    end

  end
