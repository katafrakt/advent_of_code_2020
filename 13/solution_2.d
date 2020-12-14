import std.bigint, std.algorithm, std.conv, std.array, std.stdio, std.string;

BigInt inverse(BigInt a, int m) {
  if(m == 0) return BigInt(0);
  int m0 = m;
  BigInt y = 0, x = 1;
  if(m == 1) return BigInt(0);

  while(a > 1) {
    BigInt q = a / m;
    BigInt t = m;
    m = a % m;
    a = t;
    t = y.to!BigInt;

    y = x - q * y;
    x = t;
  }

  if(x < 0) x = x + m0;
  return x;
}

unittest {
  assert(inverse(BigInt(91), 5) == 1);
  assert(inverse(BigInt(65), 7) == 4);
}

BigInt chineseRemainder(BigInt[] offsets, BigInt[] nums) {
  BigInt n = fold!((a,b) => a * b)(nums);
  BigInt[] ys, zs;
  ys.length = nums.length;
  zs.length = nums.length;

  for(int i = 0; i < nums.length; i++) {
    ys[i] = n/nums[i];
    zs[i] = inverse(ys[i], nums[i].to!int);
  }

  BigInt sum = 0;
  for(int i = 0; i < nums.length; i++) {
    sum += offsets[i] * ys[i] * zs[i];
  }
  return sum % n;
}

BigInt calcChinese(int[] nums) {
  BigInt[] offsets;
  const ulong m = nums.length;
  offsets.length = m;
  offsets[0] = 0;
  for(int i = 1; i < m; i++) {
    offsets[i] = BigInt(nums[i]-i);
  }
  BigInt[] big_nums = nums.map!(to!BigInt).array;
  return chineseRemainder(offsets, big_nums);
}

unittest {
  assert(calcChinese([5,7,13]) == 440);
  assert(calcChinese([67,7,59,61]) == 754_018);
  assert(calcChinese([17,1,13,19]) == 3417);
}

void main() {
  auto file = File("input");
   file.readln(); // first line, discard
   auto buses = file.readln();
   buses = buses.tr("x", "1");
   auto input = buses.split(",").map!(to!int).array;
   auto result = calcChinese(input);
   writeln(result);
}