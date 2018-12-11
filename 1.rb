frequency = 0

ARGF.each_line do |line|
  line = line.chomp
  sign, *rest = line.split("")
  value = Integer(rest.join)
  if sign == "+"
    frequency += value
  elsif sign == "-"
    frequency -= value
  else
    raise "unknown sign"
  end
end

puts frequency
