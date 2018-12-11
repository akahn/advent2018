require 'pry'

input = File.read('./6.input')

def next_id
  if @id
    @id = @id.succ
  else
    @id = "😀"
  end
end

class Point
  attr_reader :x, :y, :id, :closest_danger

  def self.parse(line)
    x, y = line.split(',')
    new(Integer(x), Integer(y))
  end

  def initialize(x, y)
    @x = x
    @y = y
    @danger = false
  end

  def to_s
    return id || '❔'
    prefix = @danger ? "D" : "P"
    "#{prefix}<#{x}, #{y}>"
  end

  def to_str
    to_s
  end

  def danger!(id)
    @id = id
    @danger = true
  end

  def danger?
    @danger
  end

  def distance_to(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end

  # Given a list of points, which is the closest? In the case of a tie, there is no closest.
  def closest(points)
    closest = points.sort_by {|point| self.distance_to(point) }
    if distance_to(closest[0]) != distance_to(closest[1])
      @id = closest[0].id
      @closest_danger = closest[0]
      return closest[0]
    end
  end

  def closest_danger=(point)
    return if @disqualified
    if @closest_danger
      disqualify!
      return
    end
    @closest_danger = point
  end

  def disqualify!
    @closest_danger = nil
    @id = nil
    @disqualified = true
  end
end

class Grid
  def self.construct(matrix)
    grid = Grid.new(matrix[0].length, matrix.length)
    grid.instance_variable_set :@matrix, matrix
    grid
  end

  def initialize(x, y)
    @x = x
    @y = y
    @matrix = Array.new(y) { Array.new(x) }
  end

  def set(x, y, value)
    @matrix[y][x] = value
  end

  def get(x, y)
    @matrix[y][x]
  end

  def add(point)
    set(point.x, point.y, point)
    point
  end

  def view(x, y)
    Grid.construct(@matrix[0, x].map {|row| row[0, y] })
  end

  def edges
    cells = []
    first, *middle, last = @matrix
    cells = cells + first + last
    middle.each do |row|
      cells << row.first
      cells << row.last
    end
    cells
  end

  def each
    @matrix.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell
          yield cell
        else
          set(x, y, Point.new(x, y))
          yield get(x, y)
        end
      end
    end
  end

  def to_s
    s = ''
    @matrix.each do |row|
      row.each do |cell|
        if cell
          s << cell.to_s
        else
          s << '.'
        end
      end
      s << "\n"
    end
    return s
  end
end

g = Grid.new(10,20)

g.set(0,0, '1')
g.set(1,1, '2')
g.set(2,2, '3')
g.set(3,0, '4')

if g.get(3,0) != '4'
  raise 'wrong value gotten'
end

puts g
puts
subgrid = g.view(3,2)
puts subgrid
puts



grid = Grid.new(400, 400)
danger_points = []

input.each_line do |line|
  danger_points << point = Point.parse(line)
  grid.add(point).danger!(next_id)
end

results = Hash.new { 0 }

# Iterate over each cell in the grid and calculate its distance to all danger points, recording the closest one.
grid.each do |cell|
  next if cell.danger?

  if closest = cell.closest(danger_points)
    #puts "Closest for #{cell.x},#{cell.y} is #{closest}"
    results[closest] += 1
  else
    #puts "Disqualifying #{cell} as it is equidistant to multiple danger points"
    cell.disqualify!
  end
end

# Scan the edges and accumulate which appear there, and disqualify them.
disqualified = grid.edges.map {|cell| cell.closest_danger}.uniq.compact

sorted = results.sort_by {|point, count| count}.reverse

largest_non_infinite_area = sorted.find{|item| !disqualified.include?(item[0])}.last

puts largest_non_infinite_area + 1 # Plus one for the danger space itself

#puts grid.view(400, 200)
