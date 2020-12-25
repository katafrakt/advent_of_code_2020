import std.container : DList;
import std.stdio, std.conv, std.regex;
import std.range : walkLength;

auto player1 = DList!int();
auto player2 = DList!int();

void main() {
  auto file = File("input");
  int cur_player = 0;
  auto lines = file.byLine();
  foreach(line; lines) {
    if(line == "") continue;

    if(matchFirst(line, r"Player")) {
      cur_player++;
      continue;
    }

   auto num = to!int(line);
   if(cur_player == 1) {
     player1.insertBack(num);
   } else {
     player2.insertBack(num);
   }
  }

  while(true) {
    auto num1 = player1.front;
    auto num2 = player2.front;

    player1.removeFront();
    player2.removeFront();

    if(num1 > num2) {
      player1.insertBack(num1);
      player1.insertBack(num2);
    } else {
      player2.insertBack(num2);
      player2.insertBack(num1);
    }

    if(player1.empty || player2.empty) break;
  }

  auto list = player1.empty ? player2[] : player1[];
  auto value = list.walkLength();
  auto sum = 0;
  foreach(num; list) {
    sum += num * value;
    value--;
  }

  writeln(sum);
}