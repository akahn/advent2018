require 'strscan'
require 'pry'

class Cell
  def initialize
    @claims = []
  end

  def add_claim(claim)
    claims << claim
    if claim_count > 1
      claims.each {|claim| claim.contended! }
    end
  end

  def claim_count
    claims.length
  end

  def to_s
    claim_count.to_s
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
        if cell.to_s == "0"
          s << '.'
        else
          s << cell.to_s
        end
      end
      s << "\n"
    end
    s
  end

  def apply_claim(claim)
    rows = @matrix[claim.y_offset, claim.height]
    rows.each do |row|
      row[claim.x_offset, claim.width].each do |cell|
        cell.add_claim(claim)
      end
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

    @contended = false
  end

  def contended!
    @contended = true
  end

  def contended?
    !!@contended
  end

  def to_s
    "##{order} @ #{x_offset},#{y_offset}: #{width}x#{height}"
  end
end

sheet = Sheet.new(10, 20)
sheet.apply_claim(Claim.new("#1 @ 1,3: 4x4"))
sheet.apply_claim(Claim.new("#2 @ 3,1: 4x4"))
sheet.apply_claim(Claim.new("#3 @ 5,5: 2x2"))
puts sheet

input = File.read("./3.input")
fabric = Sheet.new(1000,1000)
claims = []
input.each_line do |line|
  claims << claim = Claim.new(line)
  fabric.apply_claim(claim)
end

claims.each do |claim|
  if !claim.contended?
    puts claim
  end
end
