require 'rubygems'
require 'tree'

$object_store = []

class SteveObject
  attr_accessor :attributes
  attr_accessor :values
end

root_object = SteveObject.new
root_object_id = root_object.object_id
$root = Tree::TreeNode.new("#{root_object_id}", "")

basic_object = SteveObject.new
basic_object_id = basic_object.object_id
$root << Tree::TreeNode.new("#{basic_object_id}", "")

$current_object_id = $root["#{basic_object_id}"].name
$current_object = $root["#{basic_object_id}"]

#test = "[ test test test [ attr1: [ test ]. attr2: value2. ] test: test. test: [ test ] test ]"
test = "[1.2.3.]"
test_chars = test.split(//)
char_buffer = []
test_chars.each do |char|
  char_buffer.push(char)
end

char_buffer.each do |char|
  if char.match(/\[/)
    parent_id = $current_object_id
    parent = $root["#{$current_object_id}"]
    object = SteveObject.new
    object.attributes = []
    object.values = []
    $object_store.push(object)
    object_id = object.object_id
    $current_object << Tree::TreeNode.new("#{object_id}", "")
    $current_object.content = $current_object.content << ">#{object_id}"
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
  node_string = node.content
  auto_number = 0
  if node_string.match(/:/)
    if node_string.match(/./)
      statements = node_string.split(".")
      statements.each do |statement|
        match = statement.match(/(?<attribute>\w+)\s*:\s*(?<value>(\w+|\>\w+))/)
        unless match.nil?
          obj_id = node.name.to_i
          steve_object = nil
          $object_store.each do |obj|
            if obj.object_id == obj_id
              steve_object = obj
            end
          end
          steve_object.attributes.push(match[:attribute])
          steve_object.values.push(match[:value])
          puts steve_object.inspect
        end
      end
    end
  else
    statements = node_string.split(".")
	statements.each do |statement|
	  auto_number += 1
	  match = statement.match(/\w+/)
	  unless match.nil?
        obj_id = node.name.to_i
        steve_object = nil
        $object_store.each do |obj|
          if obj.object_id == obj_id
            steve_object = obj
          end
        end
		unless steve_object.nil?
		  steve_object.attributes.push(auto_number)
          steve_object.values.push(match[0])
		  puts steve_object.inspect
		end
      end
	end
  end
end