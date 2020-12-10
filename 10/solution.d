import std.stdio, std.algorithm, std.algorithm.sorting, std.conv, std.array;

const input = "input";

void main() {
  auto nums = File(input).byLine.map!(to!int).array.sort!("a < b");
  auto ones = 0;
  auto threes = 1;
  auto current = 0;
  foreach(num; nums) {
    const diff = num - current;
    if (diff == 1) ones++;
    if (diff == 3) threes++;
    current = num;
  }
  writeln(ones * threes);

  auto max = nums[nums.length() - 1];
  long[] values;
  values.length = max;

  for(int i = 0; i < max; i++) {
    if(nums.canFind(i+1)) {
      switch(i) {
        case 0:
          values[i] = 1;
          break;
        case 1:
          values[i] = 1 + values[0];
          break;
        case 2:
          values[i] = 1 + values[1] + values[0];
          break;
        default:
          values[i] = values[i-1] + values[i-2] + values[i-3];
      }
    } else {
      values[i] = 0;
    }
  }

  writeln(values[max-1]);
}