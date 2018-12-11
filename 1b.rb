require 'set'
require 'pry'

frequency = 0
last_frequency = nil

frequencies = Set.new

input = ARGF.read
while true do
  input.each_line do |line|
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

    if frequencies.include?(frequency)
      puts frequency
      exit
    end
    frequencies.add(frequency)
  end
end

puts frequencies.length
