test = "[this is [ a test [of the]] emergency [ broadcast ] system]"
test_chars = test.split(//)
char_buffer = []
test_chars.each do |char|
  char_buffer.push(char)
end

class TestObject
  attr_accessor :parent
  attr_accessor :children
  attr_accessor :stack_level
end

$current_object = nil
$old_object = nil
$stack_level = 0
$object_stack = []

def test_char(char,pos)
  if char =~ /\[/
    $stack_level += 1
    obj = TestObject.new
    obj.stack_level = $stack_level
    $object_stack.push(obj)
    print " [ #{obj.stack_level}"
    $current_object = obj
  elsif char =~ /\]/
    $stack_level -= 1
    parent = nil
    $object_stack.each do |obj|
      if obj.stack_level == $stack_level
        parent = obj
        $current_object = parent
      end
    end
    print " ] #{$current_object.stack_level}"
  else
    print "#{$current_object.stack_level}"
  end
end

test_chars.each_with_index do |char,pos|
  test_char(char,pos)
end