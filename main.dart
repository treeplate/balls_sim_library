import 'logic.dart';
import 'package:test/test.dart';
import 'dart:io';

// Required for repl.it

// Used for testing library

void main() async {
  Gameboard board = Gameboard.parse(File("game.balls").readAsStringSync());
  while(true) {
    print("\u001b[2J\u001b[0;0f$board\n");
    await Future.delayed(Duration(milliseconds: 200));
    board.tick();
  }
}

void myTest() {
  test("Vec2.rotated", () {
    Vec2 vector = Vec2.north();
    expect(vector = vector.rotated(true), Vec2.east());
    expect(vector = vector.rotated(true), Vec2.south());
    expect(vector = vector.rotated(true), Vec2.west());
    expect(vector = vector.rotated(true), Vec2.north());
  });

  test("Vec2.rotated anticlockwise", () {
    Vec2 vector = Vec2.north();
    expect(vector = vector.rotated(false), Vec2.west());
    expect(vector = vector.rotated(false), Vec2.south());
    expect(vector = vector.rotated(false), Vec2.east());
    expect(vector = vector.rotated(false), Vec2.north());
  });

  test("Ball.getUpdatedBall", (){
    Ball ball = Ball(Vec2(0, 1), Vec2.east());
    ball = ball.getUpdatedBall();
    expect(ball.velocity, Vec2.east());
    expect(ball.position, Vec2.east() + Vec2(0, 1));
  });

  group("World tests/", () {
    Gameboard game = Gameboard.parse(File("test_1.balls").readAsStringSync());
    test("Gameboard.parse and Gameboard.toString", (){
      print("Start:\n$game");
      expect(game.toString(), "#####\n#   #\n# v #\n#   #\n#####");
    });
    test("Gameboard.tick moves balls", () {
      game.tick();
      print("After 1 tick:\n$game");
      expect(game.toString(), "##########\n##      ##\n##      ##\n##  vv  ##\n##########");
    });
    test("Gameboard.toString; special case", () {
      game.tick();
      print("After 2 ticks:\n$game");
      expect(game.toString(), "##########\n##      ##\n##      ##\n##      ##\n####XX####");
    });
    test("Gameboard.tick; bounceback", () {
      game.tick();
      print("After 3 ticks:\n$game");
      expect(game.toString(), "##########\n##      ##\n##      ##\n##  AA  ##\n##########");
    });
  });
}