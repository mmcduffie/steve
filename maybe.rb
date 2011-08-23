require 'rubygems'
require 'tree'

root_object = Object.new
root_object_id = root_object.object_id
$root = Tree::TreeNode.new("#{root_object_id}", "")

basic_object = Object.new
basic_object_id = basic_object.object_id
$root << Tree::TreeNode.new("#{basic_object_id}", "")

$current_object_id = $root["#{basic_object_id}"].name
$current_object = $root["#{basic_object_id}"]

test = "[111111[22222[33333333]]111111[4444444]1111111]"
test_chars = test.split(//)
char_buffer = []
test_chars.each do |char|
  char_buffer.push(char)
end

char_buffer.each do |char|
  if char.match(/\[/)
    parent_id = $current_object_id
    parent = $root["#{$current_object_id}"]
    object = Object.new
    object_id = object.object_id
    $current_object << Tree::TreeNode.new("#{object_id}", "")
    $root.each do |node|
      if node.name == object_id.to_s
        $current_object = node
      end
    end
    $current_object_id = object_id
  elsif char.match(/\]/)
    $current_object = $current_object.parent
  else
    $current_object.content = $current_object.content << char
  end
end

$root.each do |node|
  puts node.content
end