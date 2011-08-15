test = "[this is [ a test [of the]] emergency [ broadcast ] system]"
test_chars = test.split(//)
char_buffer = []
test_chars.each do |char|
  char_buffer.push(char)
end

$current_object = nil
$old_object = nil

def test_char(char,pos)
  if char =~ /\[/
    $old_object = $current_object
    $current_object = Object.new.object_id
    puts " [ #{$current_object} "
  elsif char =~ /\]/
    $current_object = $old_object
    puts " #{$old_object} ]"
  end
end

test_chars.each_with_index do |char,pos|
  test_char(char,pos)
end