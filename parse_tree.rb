class TreeNode
  attr_accessor :content
  attr_accessor :children
  def initialize(parent,content)
    @parent, @content = parent, content
    unless parent == nil then parent.add_child(self) end
  end
  def add_child(child)
    @children ||= []
    @children.push(child)
  end
  def output_tree
    puts self.content
    @children.each do |node|
      puts "  #{node.content}"
      node.children.each do |child_node|
        puts "    #{child_node.content}"
      end
    end
  end
end

root = TreeNode.new(nil,"Root")
child1 = TreeNode.new(root,"Child1")
child2 = TreeNode.new(root,"Child2")
child3 = TreeNode.new(child1,"Child3")
child4 = TreeNode.new(child1,"Child4")
child5 = TreeNode.new(child2,"Child5")
child6 = TreeNode.new(child2,"Child6")
root.output_tree