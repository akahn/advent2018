input = ARGF.read

two_repeats = 0
three_repeats = 0
hashes = []

input.each_line do |line|
  line = line.chomp
  chars = Hash.new(0)
  hashes << chars
  line.each_char do |char|
    chars[char] += 1
  end
end

hashes.each do |chars|
  if chars.values.include?(2)
    two_repeats += 1
  end

  if chars.values.include?(3)
    three_repeats += 1
  end
end

puts two_repeats * three_repeats
