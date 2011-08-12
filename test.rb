source = <<-eos
  [    []
     
       [   []     ]     ]
     
       eos
       
chars = source.split(//)

$mem = []
$stack_level = 0

def test_char(char)
  if char =~ /\[/
    $mem.push([])
    $stack_level += 1
  end
end

chars.each do |c|
  test_char(c)
end

puts $mem.inspect