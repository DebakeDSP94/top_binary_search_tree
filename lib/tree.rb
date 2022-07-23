# frozen_string_literal: true

require_relative 'node'

# creates binary search tree and associated methods
class Tree
  def initialize(array)
    array = array.sort.uniq
    @root = build_tree(array)
  end

  def build_tree(array, start = 0, last = array.length - 1)
    return nil if start > last

    mid = (start + last) / 2
    root = Node.new(array[mid])
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, last)
    root
  end

  def insert(value, node = @root)
    return nil if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      delete(value.node.left)
    elsif value > node.data
      delete(value.node.right)
    end

    if node.data == value
      return node.right if node.left.nil?
      return node.left if node.left.nil?
    else
      node.data = most_left(node.right)
      node.right = delete(node.data, node.right)
    end
  end

  def most_left(node)
    most_left = node.data
    while node.left
      most_left = node.left.data
      node = node.left
    end
    most_left
  end

  def find(value, node = @root)
    return if node.data.nil?

    found = nil
    if value < node.data
      return 'not found' if node.left.nil?

      find(value, node.left)
    elsif value > node.data
      return 'not found' if node.right.nil?

      find(value, node.right)
    elsif value == node.data
      found = node
    end
    found
  end

  def level_order(queue = [@root], result = [], &block)
    return result if queue.empty?

    queue << queue.first.left if queue.first.left
    queue << queue.first.right if queue.first.right
    if block_given?
      yield(queue.shift)
      level_order(queue, &block)
    else
      result << queue.shift.data
      level_order(queue, result)
    end
  end

  def inorder(node = @root, result = [], &block)
    return if node.nil?

    inorder(node.left, result, &block)
    yield node if block_given?
    result << node.data
    inorder(node.right, result, &block)
    result
  end

  def preorder(node = @root, result = [], &block)
    return if node.nil?

    yield node if block_given?
    result << node.data
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)
    result
  end

  def postorder(node = @root, result = [], &block)
    return if node.nil?

    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    yield node if block_given?
    result << node.data
  end

  def height(node = @root)
    return 0 if node.nil?

    left = node.left ? height(node.left) : 0
    right = node.right ? height(node.right) : 0
    left > right ? left + 1 : right + 1
  end

  def depth(node = @root)
    height(@root) - height(node)
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    @root = build_tree(inorder)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
p tree.balanced?
p tree.level_order
p tree.inorder
p tree.preorder
p tree.postorder
p tree.pretty_print
tree.insert(105)
tree.insert(110)
tree.insert(115)
tree.insert(120)
p tree.balanced?
p tree.pretty_print
tree.rebalance
p tree.balanced?
p tree.pretty_print
p tree.find(20)
p tree.height
p tree.depth
