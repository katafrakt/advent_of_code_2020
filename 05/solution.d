import std.algorithm, std.stdio, std.string, std.container.rbtree;

void main() {
  auto file = File("input");
  auto passes = file.byLine().map!(s => cast(char[])s);
  auto max_id = 0;
  auto ids = redBlackTree!int([]);

  foreach(pass; passes) {
    auto front = 0;
    auto back = 127;
    auto left = 0;
    auto right = 7;

    foreach(x; pass) {
      switch(x) {
        case('F'):
          back = ((front + back)+1)/2 - 1;
          break;
        case('B'):
          front = ((front + back)+1)/2;
          break;
        case('R'):
          left = (left+right+1)/2;
          break;
        case('L'):
          right = (left+right+1)/2 - 1;
          break;
        default:
          break;
      }
    }
    assert(front == back);
    assert(left == right);
    auto seat_id = (front * 8) + left;
    ids.insert(seat_id);
    if(seat_id > max_id) max_id = seat_id;
  }
  writeln(max_id);

  for(int i=1;i<127;i++) {
    for(int j=0;j<8;j++) {
      const seat_id = i * 8 + j;
      if ((seat_id + 1 in ids) && (seat_id - 1 in ids) && !(seat_id in ids)) writeln(seat_id);
    }
  }
}