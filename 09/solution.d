import std.stdio, std.range, std.conv, std.algorithm, std.file, std.string;

const file_name = "input";
const preamble_size = 25;
int[preamble_size] preamble;

void shiftPreamble(int num) {
  preamble = preamble[1..preamble_size] ~ [num];
}

bool hasTwoElementsSummingTo(int sum) {
  for(int i = 0; i < preamble_size; i++) {
    for(int j = i+1; j < preamble_size; j++) {
      if(preamble[i] + preamble[j] == sum) return true;
    }
  }
  return false;
}

void main() {
  int bad_number;
  auto file = File(file_name);
  auto range = file.byLine();
  preamble = range.take(preamble_size).map!(to!int).array;
  foreach (line; range) {
    auto num = to!int(line);
    if(!hasTwoElementsSummingTo(num)) {
      bad_number = num;
      writeln(num);
      break;
    }
    shiftPreamble(num);
  }
  file.close();

  auto array = file_name.readText().splitLines();
  bool found = false;

  for(int i = 0; i < array.length; i++) {
    if(found) break;
    long sum = 0;
    long min_num = int.max;
    long max_num = 0;

    for(int j = i; j < array.length; j++) {
      auto num = to!long(array[j]);

      sum += num;
      if(num < min_num) min_num = num;
      if(num > max_num) max_num = num;
      if(sum == bad_number) {
        writeln(min_num + max_num);
        found = true;
        break;
      }
      if(sum > bad_number) {
        break;
      }
    }
  }
}