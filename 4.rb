require 'time'
require 'pry'

input = File.readlines('./4.input')

puts "Total lines: #{input.length}"

class LogEntry
  attr_reader :timestamp

  def initialize(raw)
    @raw = raw
    @timestamp = Time.parse(raw.match(/\[(.+)\]/)[1])
  end

  def <=>(other)
    self.timestamp <=> other.timestamp
  end

  def to_s
    @raw
  end

  def new_guard
    matches = @raw.match(/Guard #(.+) begins shift/)
    return matches && Integer(matches[1])
  end

  def sleep?
    @raw.match?(/falls asleep/)
  end

  def awoke?
    @raw.match?(/wakes up/)
  end
end

class Guard
  attr_reader :total_minutes, :id, :minute_distribution

  @@guards = {}

  def self.all
    @@guards.values.sort.reverse
  end

  def self.[](id)
    if guard = @@guards[id]
      return guard
    end

    @@guards[id] = Guard.new(id)
  end

  def initialize(id)
    @id = id
    @total_minutes = 0
    @minute_distribution = Hash.new { 0 }
  end

  def sleep(time)
    @sleeping = true
    @sleep_started = time
  end

  def awake(time)
    if !@sleeping
      raise "wasn't sleeping"
    end

    duration = time - @sleep_started
    @total_minutes += (duration.to_i / 60 + 1)

    if @sleep_started.hour != time.hour
      raise "mismatched hours"
    end

    (@sleep_started.min...time.min).to_a.each do |min|
      @minute_distribution[min] += 1
    end

    @sleep_started = nil
  end

  def <=>(other)
    self.total_minutes <=> other.total_minutes
  end

  def sleepiest_minute
    return if @minute_distribution.empty?
    @minute_distribution.invert.sort.last.last
  end

  def to_s
    "##{@id} total=#{@total_minutes}, sleepiest_minute=#{sleepiest_minute}"
  end
end

class GuardSet
  def initialize
    guards = {}
  end

  def add_sleep(guard, duration)
  end
end

class GuardStats
  def self.process(log_entries)
    i = 0
    guards = GuardSet.new
    sleep_begun = nil
    current_guard = nil

    log_entries.each do |entry|
      puts entry
      if entry.new_guard
        current_guard = Guard[entry.new_guard]
      elsif entry.sleep?
        current_guard.sleep(entry.timestamp)
      elsif entry.awoke?
        current_guard.awake(entry.timestamp)
        puts current_guard if current_guard.id == 3323
      else
        puts entry
        raise 'unknown state'
      end
      i += 1
    end

    puts "Total processed: #{i}"
  end
end

entries = input.map {|line| LogEntry.new(line) }
entries.sort!

GuardStats.process(entries)
puts Guard.all

sleepiest = Guard.all.first

puts "Sleepiest: #{sleepiest}"
puts "Result #{sleepiest.id * sleepiest.sleepiest_minute}"
