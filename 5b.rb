require 'pry'

input = File.read('./5.input')

lowers = 'a'..'z'
uppers = 'A'..'Z'

PAIR_REGEXEN = (uppers.zip(lowers)).map {|pair| Regexp.new(pair.join("|") )}

pairs = (uppers.zip(lowers) + lowers.zip(uppers)).map &:join
ALL_PAIRS_REGEX = Regexp.new(pairs.join("|"))

def remove_opposite_cased_pairs(input)
  input.gsub(ALL_PAIRS_REGEX, "")
end

def process_repeatedly(input)
  until remove_opposite_cased_pairs(input) == input
    input = remove_opposite_cased_pairs(input)
  end


  input
end

def test_removal
  input = "abBcdEe"
  output = remove_opposite_cased_pairs(input)
  if output != "acd"
    raise "expected 'acd'. got '#{output}'"
  end
end

inputs = {}
PAIR_REGEXEN.each do |regex|
  processed = input.gsub(regex, "")
  inputs[regex] = processed
end

lengths = []

inputs.each do |_, input|
  lengths << process_repeatedly(input).length
  print '.'
end

puts lengths.min

