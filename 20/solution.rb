class Tile
  LOOKUP = {
    e: :w,
    w: :e,
    n: :s,
    s: :n
  }.freeze

  def self.from_input(str)
    str = str.gsub('#',"1").gsub(".", "0")
    lines = str.split("\n")
    lines.shift =~ /Tile (\d+):/
    label = $1.to_i
    variants = []
    lines.map! {|l| l.split("")}

    add_variants = ->() {
      4.times do
        line_north = lines[0]
        line_south = lines[9]
        line_west = lines.transpose[0]
        line_east = lines.transpose[9]

        variants << {
          n: line_north.join.to_i(2),
          e: line_east.join.to_i(2),
          s: line_south.join.to_i(2),
          w: line_west.join.to_i(2)
        }

        lines = lines.transpose.map(&:reverse)
      end
    }

    add_variants.()

    lines = lines.reverse

    add_variants.()

    lines = lines.reverse.transpose.reverse

    add_variants.()

    new(label, variants)
  end

  attr_reader :label, :variants

  def initialize(label, variants)
    @label = label
    @variants = variants
  end

  # { e: [...], s: [...]}
  def matching(matches)
    variants.select { |v| matches.all? { |direction, variant| v[LOOKUP[direction]] == variant[direction] } }
  end
end

class Entry
  attr_reader :label, :variant

  def initialize(label, variant)
    @label = label
    @variant = variant
  end

  def to_s
    "#{label}: #{@variant.values.join(',')}"
  end
end

input = File.read("test")
tiles = input.split("\n\n").map { |i| Tile.from_input(i) }

candidates = tiles.flat_map do |t|
  t.variants.map {|v| [Entry.new(t.label, v)]}
end.uniq
puts candidates

cur_pos = [0,1]
8.times do
  candidates.map! do |c|
    used_tiles = c.map(&:label)
    
    if cur_pos[0] >= 1
      to_north = c[cur_pos[0]*3 + cur_pos[1] - 3]
    end

    if cur_pos[1] >= 1
      to_west = c.last
    end

    tiles.flat_map do |tile|
      next [] if used_tiles.include?(tile.label)

      args = {}
      args[:s] = to_north.variant if to_north
      args[:e] = to_west.variant if to_west
      tile.matching(args).map{ |v| c + [Entry.new(tile.label, v)] }
    end.reject(&:empty?).flatten
  end.reject!(&:empty?)

  cur_pos[1] += 1
  if cur_pos[1] == 3
    cur_pos[1] = 0
    cur_pos[0] += 1
  end
end

l = candidates.last
puts l[0].label * l[2].label * l[6].label * l[8].label