import 'logic.dart';
import 'package:test/test.dart';

// Required for repl.it

// Used for testing library
void main() {
  test("Ball.toString", () {
    expect(Ball(Vec2(0, 0), Vec2.north()).toString(), "Ball(position: Pos2(0, 0), velocity: Vec2(0, -1))");
  });

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
}