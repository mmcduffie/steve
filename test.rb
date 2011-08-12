source = <<-eos
  [    []
     
       [   []     []     ]
     
       eos
       
chars = source.split(//)

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

puts $mem.inspect
puts $stack_level