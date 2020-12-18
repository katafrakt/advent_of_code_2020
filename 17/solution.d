import std.string, std.stdio, std.algorithm;

struct Point {
  long x, y, z;

  Point[26] getNeighborsCoords() {
    Point[26] points;
    int idx = 0;

    for(long i = x - 1; i <= x + 1; i++) {
      for(long j = y - 1; j <= y + 1; j++) {
        for(long k = z - 1; k <= z + 1; k++) {
          if(i != x || j != y || k != z) {
            points[idx] = Point(i,j,k);
            idx++;
          }
        }
      }
    }

    return points;
  }

  // bool opEquals(Object x) {
  //   Point other = cast(Point) x;
  //   return this.x == other.x && this.y == other.y && this.z == other.z;
  // }

  bool opEquals()(auto ref const Point other) const {
    return this.x == other.x && this.y == other.y && this.z == other.z;
  }

  // override ulong toHash() const @safe pure nothrow {
  //   return (this.x * 10_000) + (this.y * 100) + this.z;
  // }

  size_t toHash() const pure nothrow {
        size_t hash = x.hashOf();
        hash = y.hashOf(hash);
        hash = z.hashOf(hash);
        return hash;
    }

  string toString() {
    return format("(%d,%d,%d)",this.x,this.y,this.z);
  }
}

class Cube {
  Point coord;
  bool active;

  this(Point coord, bool active) {
    this.coord = coord;
    this.active = active;
  }

  Cube clone(bool state) {
    return new Cube(this.coord, state);
  }

  override string toString() {
    return format("%s (%s)", this.coord, this.active);
  }
}

class Plane {
  Cube[Point] cubes;
  long min_x, min_y, min_z, max_x, max_y, max_z;

  void putActiveAt(Point c) {
    this.cubes[c] = new Cube(c, true);
  }

  Plane createExpanded() {
    auto plane = new Plane();
    plane.min_x = this.min_x - 1;
    plane.min_y = this.min_y - 1;
    plane.min_z = this.min_z - 1;
    plane.max_x = this.max_x + 1;
    plane.max_y = this.max_y + 1;
    plane.max_z = this.max_z + 1;
    return plane;
  }

  long countActive() {
    int sum = 0;
    foreach(c; this.cubes) {
      if(c.active) sum++;
    }
    return sum;
  }

  void setSize(long size) {
    this.min_x = 0; this.min_y = 0; this.min_z = 0;
    this.max_x = size; this.max_y = size; this.max_z = 0;
  }

  void draw() {
    for(long y = min_y; y <= max_y; y++) {
      for(long z = min_z; z <= max_z; z++) {
        for(long x = min_x; x <= max_x; x++) {
          auto p = Point(x,y,z);
          if((p in cubes) !is null) {
            write("#");
          } else {
            write(".");
          }
        }
        write(" ");
      }
      writeln("");
    }
  }
}

void main() {
  long z = 0;
  long x = 0;
  long y = 0;
  auto plane = new Plane();

  int cycles = 6;

  auto file = File("input");
  auto range = file.byLine();
  foreach(line; range) {
    x = 0;
    auto cubes = line.split("");
    foreach(cube; cubes) {
      if(cube == "#") {
        auto point = Point(x,y,z);
        plane.putActiveAt(point);
      }
      x++;
    }
    y++;
  }

  plane.setSize(y-1);

  for(int i = 0; i < cycles; i++) {
    auto new_plane = plane.createExpanded();

    for(long nz = new_plane.min_z; nz <= new_plane.max_z; nz++) {
      for(long ny = new_plane.min_y; ny <= new_plane.max_y; ny++) {
        for(long nx = new_plane.min_x; nx <= new_plane.max_x; nx++) {
          int num_active_neighbors = 0;
          auto point = Point(nx,ny,nz);
          auto neighbours = point.getNeighborsCoords();

          foreach(nghb; neighbours) {
            auto cube = nghb in plane.cubes;
            if(cube !is null) num_active_neighbors++;
          }

          auto cube = point in plane.cubes;
          if(cube && (num_active_neighbors == 2 || num_active_neighbors == 3)) {
            new_plane.putActiveAt(point);
          } else if(cube is null && num_active_neighbors == 3) {
            new_plane.putActiveAt(point);
          }
        }
      }
    }
    plane = new_plane;
  }
  writeln(plane.countActive());
}