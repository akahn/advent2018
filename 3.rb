require 'strscan'
require 'pry'

class Cell
  def initialize
    claims = []
  end

  def add_claim(claim)
    claims << claim
  end

  def claim_count
    claims.length
  end

  def to_s
    claim_count
  end

  private

  attr_reader :claims
end
class Sheet
  def initialize(x, y, initial = 0)
    @matrix = Array.new(y) { (Array.new(x) { Cell.new }) }
  end

  def to_s
    s = ''
    @matrix.each do |row|
      row.each do |cell|
        s << cell.to_s + "  "
      end
      s << "\n"
    end
    s
  end

  def apply_claim(claim)
    rows = @matrix[claim.y_offset, claim.height]
    rows.each do |row|
      row.fill(claim.x_offset, claim.width) {|i| row[i].add_claim }
    end
  end

  def count
    count = 0
    @matrix.each do |row|
      row.each do |cell|
        if yield(cell)
          count += 1
        end
      end
    end
    count
  end
end

class Claim
  attr_reader :order, :x_offset, :y_offset, :width, :height

  def initialize(claim)
    ss = StringScanner.new(claim)
    ss.skip(/#/)
    @order = ss.scan(/\d+/).to_i
    ss.skip(/ @ /)
    @x_offset = ss.scan(/\d+/).to_i
    ss.skip(/,/)
    @y_offset = ss.scan(/\d+/).to_i
    ss.skip(/: /)
    @width = ss.scan(/\d+/).to_i
    ss.skip(/x/)
    @height = ss.scan(/\d+/).to_i
  end

  def to_s
    "##{order} @ #{x_offset},#{y_offset}: #{width}x#{height}"
  end
end

input = File.read("./3.input")
fabric = Sheet.new(1000,1000)
input.each_line do |line|
  claim = Claim.new(line)
  fabric.apply_claim(claim)
end

puts fabric.count {|value| value > 1 }
