import 'package:quiver/core.dart';

class Vec2 {
  Vec2(this.dx, this.dy);
  Vec2.north(): dx = 0, dy = -1;
  Vec2.south(): dx = 0, dy = 1;
  Vec2.east(): dx = 1, dy = 0;
  Vec2.west(): dx = -1, dy = 0;
  final int dx;
  final int dy;

  Vec2 operator -() {
    return Vec2(-dx, -dy);
  }

  Vec2 operator +(Vec2 other) => Vec2(other.dx+dx, other.dy+dy);

  bool operator ==(dynamic other) => other is Vec2 && other.dx == dx && other.dy == dy;

  int get hashCode => hash2(dx, dy);

  Vec2 rotated(bool clockwise) {
    return Vec2(rotate(clockwise, dx, dy), rotate(!clockwise, dy, dx));
  }

  String toString() => "$dx, $dy";
}

int rotate(bool clockwise, int target, int helper) {
  int direction = clockwise ? -helper : helper;
  if(direction == 0) return 0; else return target+direction;
} 

class Ball {
  Ball(this.position, this.velocity);
  final Vec2 position;
  final Vec2 velocity;
  String toString() => "Ball(position: Pos2($position), velocity: Vec2($velocity))";
  Ball getUpdatedBall() {
    return Ball(position + velocity, velocity);
  }
}

class Gameboard {
  
  /// The current state of the model.
  /// The integer means how many balls there are in that 
  /// square.
  /// -1 means wall.
  List<List<int>> get grid => null; //TODO: grid
  /// Ticks the game
  void tick() {
    //TODO: implement tick
    // - move balls
    //   - for each ball
    //     - change position by velocity
    // - handle collisions
    //   - have a function that takes a list of balls and
    //   - returns a list of balls that should have the 
    //   - same positions but different velocities
  }

}