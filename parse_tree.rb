class TreeNode
  def initialize(parent,content)
    @children = []
    @parent, @content = parent, content
    unless parent == nil then parent.add_child(self) end
  end
  def add_child(child)
    @children.push(child)
  end
end

root = TreeNode.new(nil,"Root")
child1 = TreeNode.new(root,"Child1")
child2 = TreeNode.new(root,"Child2")
puts root.inspect