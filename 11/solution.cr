struct Seat
  property x, y, occupied

  def initialize(@x : Int32, @y : Int32, @occupied : Bool)
  end
end

seating = [] of Seat

fname = "input"
File.open(fname) do |file|
  file.each_line.with_index do |line, lidx|
    line.split("").each_with_index do |val, vidx|
      if val == "L"
        seating << Seat.new(lidx, vidx, false)
      end
    end
  end
end

def calculate_seating_hash(seating)
  seating
    .map { |s| [s.x, s.y, s.occupied.to_s].join("-") }
    .join(" ")
end

def get_adjacent_seats(seating, seat)
  seating.select do |candidate|
    candidate.x >= seat.x - 1 && candidate.x <= seat.x + 1 &&
      candidate.y >= seat.y - 1 && candidate.y <= seat.y + 1 &&
      [candidate.x, candidate.y] != [seat.x, seat.y]
  end
end

def solution1(seating)
  current_hash = ""
  loop do
    new_hash = calculate_seating_hash(seating)
    break if new_hash == current_hash

    new_seating = [] of Seat
    seating.each do |seat|
      adjacent = get_adjacent_seats(seating, seat)
      if seat.occupied && adjacent.count { |s| s.occupied } >= 4
        new_seating << Seat.new(seat.x, seat.y, false)
      elsif !seat.occupied && adjacent.all? { |s| !s.occupied }
        new_seating << Seat.new(seat.x, seat.y, true)
      else
        new_seating << seat
      end
    end

    print "."
    seating = new_seating
    current_hash = new_hash
  end

  puts seating.count { |s| s.occupied }
end

solution1(seating)