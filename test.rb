require 'rubygems'
require 'tree'
require 'set'

source = <<-eos
  [    []
     
       [   []     []     ]
     
       eos
       
chars = source.split(//)

$granted_ids = Set.new

def create_node_id
  old_length = $granted_ids.length
  node_id = 1000000000 + rand(8999999999)
  $granted_ids.add(node_id)
  new_length = $granted_ids.length
  if new_length > old_length
    return node_id
  else
    create_node_id
  end
end

$mem = []
$stack_level = 0

def test_char(char,pos)
  if char =~ /\[/
    $mem.push([])
    $stack_level += 1
  elsif char =~ /\]/
    $stack_level -= 1
  end
end

chars.each_with_index do |c,i|
  test_char(c,i)
end

#module Tree
#  class TreeNode
#    def initialize(content = nil)
#      @name = self.object_id
#      @content = content
#      self.set_as_root!
#      @children_hash = Hash.new
#      @children = []
#    end
#  end
#end

root_node = Tree::TreeNode.new("Root")
root_node << child1 = Tree::TreeNode.new("child1")
root_node << child2 = Tree::TreeNode.new("child2")
child1 << Tree::TreeNode.new("child3")
child1 << Tree::TreeNode.new("child4")
puts root_node.print_tree