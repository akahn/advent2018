require 'pry'

input = File.read('./5.input')

lowers = 'a'..'z'
uppers = 'A'..'Z'

pairs = (uppers.zip(lowers) + lowers.zip(uppers)).map &:join

PAIRS_REGEX = Regexp.new(pairs.join("|"))

class CharEater
  def initialize
    @gut = ""
  end

  def feed(char)
    if !opposite_case?(@gut[-1], char)
      @gut << char
    end
  end

  def to_s
    @gut
  end

  private

  def opposite_case?(a, b)
    return false if a == nil || b == nil
    return false if a == b

    a.downcase == b.downcase
  end
end


def remove_opposite_cased_pairs(input)
  input.gsub(PAIRS_REGEX, "")
end

def opposite_case?(a, b)
  return false if a == b

  a.downcase == b.downcase
end

def process_repeatedly(input)
  until remove_opposite_cased_pairs(input) == input
    input = remove_opposite_cased_pairs(input)
    puts input.length
  end


  input
end

def test_removal
  input = "abBcdEe"
  output = input.gsub(PAIRS_REGEX, "")
  if output != "acd"
    raise "expected 'acd'. got '#{output}'"
  end
end

puts process_repeatedly(input).length

