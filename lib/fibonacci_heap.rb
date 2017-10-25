require "fibonacci_heap/version"

module FibonacciHeap
  def self.new
    Heap.new
  end

  class Heap
    attr_reader :n
    attr_reader :rank
    attr_reader :trees
    attr_reader :marks
    attr_reader :min

    def initialize
      @n = 0
      @rank = 0
      @trees = 0
      @marks = 0
      @ranks = Hash.new
    end

    def insert(key)
      @n += 1
      @trees += 1

      tmp = Node.new(key)

      if @min.nil?
        @min = tmp
      else
        @min.concatenate!(tmp)

        if key < @min.key
          @min = tmp
        end
      end
    end

    def delete_min!
      @n -= 1
      min_children = @min.child
      @trees -= 1
      @trees += @min.rank

      # Delete current min and set new min
      if @min.left == @min
        # Empty list case
        find_min_and_reset_rank(min_children)
      else
        tmp_root = @min.left

        @min.delete!

        tmp_root.concatenate!(min_children)
        find_min_and_reset_rank(tmp_root)
      end

      consolidate!
      @ranks = Hash.new
    end

    private

    def consolidate!(node = nil)
      node ||= @min

      return if @ranks.size == @trees

      if @ranks[node.rank].nil? || @ranks[node.rank] == node
        @ranks[node.rank] = node
      else
        node =
          if @ranks[node.rank].key < node.key
            make_child(@ranks[node.rank], node)
          else
            make_child(node, @ranks[node.rank])
          end

        consolidate!(node)
      end

      consolidate!(node.right)
    end

    def make_child(node, child_node)
      @trees -= 1
      child_node.delete!

      if node.child.nil?
        node.child = child_node
        node.child.parent = node
      else
        node.child.concatenate!(child_node)
      end

      @ranks.delete(node.rank)
      node.rank += 1

      if node.rank > @rank
        @rank = node.rank
      end

      # Ruby implicitly returns the last line
      node
    end

    def find_min_and_reset_rank(list)
      @rank = list.rank
      first = list
      @min = list

      next_one = list

      loop do
        next_one = next_one.left

        if next_one == first
          break
        end

        if next_one.rank > @rank
          @rank = next_one.rank
        end

        if next_one.key < @min.key
          @min = next_one
        end
      end
    end
  end

  class Node
    attr_reader :key
    attr_accessor :parent
    attr_accessor :child
    attr_accessor :rank
    attr_accessor :left
    attr_accessor :right

    def initialize(key)
      @key = key
      @rank = 0
      @mark = false

      @left = self
      @right = self
    end

    def mark!
      @mark = true
    end

    def marked?
      @mark
    end

    def moved!
      @mark = false
    end

    def delete!
      @left.right = @right
      @right.left = @left
      @right = self
      @left = self
    end

    def concatenate!(l2)
      return if l2.nil?

      iterator = l2

      loop do
        iterator.parent = @parent
        break if iterator.left == l2
      end

      l1l = @left
      l2l = l2.left

      l1l.right = l2
      l2.left = l1l

      l2l.right = self
      @left = l2l
    end
  end
end
