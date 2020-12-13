import std.math, std.conv, std.bigint, std.algorithm, std.array, std.string, std.stdio;

struct Result {
  BigInt offset;
  BigInt cycle;
}

Result* find_next_cycle(Result* previous, BigInt next, int index) {
  writeln("offset=", previous.offset, " cycle=", previous.cycle, " current=", next);
  BigInt candidate = (previous.offset/next) * next - previous.offset - index;
  BigInt helper = candidate;
  long i = 0; // helper counter to avoid bigint addition in the loop
  while(true) {
    helper = helper % previous.cycle; 
    if(helper == 0) break;
    i++;
    helper += next;
  }
  return new Result(candidate + (next*i) + previous.offset, previous.cycle * BigInt(next));
}

BigInt find_min_common_cycle(int[] cycles) {
  auto big_cycles = cycles.map!(a => BigInt(a));
  auto result = new Result(BigInt(0), big_cycles[0]);
  for(int i = 1; i < cycles.length; i++) {
    if(cycles[i] == 0) continue;
    result = find_next_cycle(result, big_cycles[i], i);
  }
  return result.offset;
}

void main() {
   auto file = File("input");
   file.readln(); // first line, discard
   auto buses = file.readln();
   buses = buses.tr("x", "0");
   auto input = buses.split(",").map!(to!int).array;
   auto result = find_min_common_cycle(input);
   writeln(result);
}

unittest {
  assert(find_min_common_cycle([5,7,13]) == 440);
  assert(find_min_common_cycle([17,0,13,19]) == 3417);
  assert(find_min_common_cycle([7,13,0,0,59,0,31,19]) == 1_068_781);
  assert(find_min_common_cycle([67,7,59,61]) == 754_018);
  assert(find_min_common_cycle([67,0,7,59,61]) == 779_210);
  assert(find_min_common_cycle([67,7,0,59,61]) == 1_261_476);
  assert(find_min_common_cycle([1789,37,47,1889]) == 1_202_161_486);
}
