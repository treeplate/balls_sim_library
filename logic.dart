import 'package:quiver/core.dart';

List<String> colors = ["\u001b[31m", "\u001b[32m", "\u001b[33m", "\u001b[34m", "\u001b[35m"];

class Vec2 {
  Vec2(this.dx, this.dy);
  Vec2.north(): dx = 0, dy = -1;
  Vec2.south(): dx = 0, dy = 1;
  Vec2.east(): dx = 1, dy = 0;
  Vec2.west(): dx = -1, dy = 0;
  factory Vec2.ihat() => Vec2.east();
  factory Vec2.jhat() => Vec2.south();
  final int dx;
  final int dy;

  Vec2 operator -() {
    return Vec2(-dx, -dy);
  }

  Vec2 operator *(int scalar) {
    return Vec2(dx*scalar, dy*scalar);
  }

  Vec2 operator +(Vec2 other) => Vec2(other.dx+dx, other.dy+dy);

  bool operator ==(dynamic other) => other is Vec2 && other.dx == dx && other.dy == dy;

  int get hashCode => hash2(dx, dy);

  Vec2 rotated(bool clockwise) {
    return Vec2(rotate(clockwise, dx, dy), rotate(!clockwise, dy, dx));
  }

  String toString() => "$dx: $dy";
}

int rotate(bool clockwise, int target, int helper) {
  int direction = clockwise ? -helper : helper;
  if(direction == 0) return 0; else return target+direction;
} 

abstract class Thing {}

class Ball extends Thing {
  Ball(this.position, this.velocity, [int oldcolor, this.generator = false, this.genl = 5]): color = oldcolor ?? nC {
    if(oldcolor == null) {
      nC = (nC + 1) % colors.length;
    }
  }
  bool generator;
  int genri = 0;
  int genl;
  final Vec2 position;
  final Vec2 velocity;
  final int color;
  static int nC = 0;
  String toString() => generator ? "$genri$genri" : colors[color] + "$genri$genri" + "\u001b[0m";//(velocity == Vec2.north() ? "A" : velocity == Vec2.west() ? "<" : velocity == Vec2.south() ? "v" : ">") + "\u001b[0m";
  Ball getUpdatedBall() {
    return Ball(position + velocity, velocity, genri == genl-1 ? null : color % colors.length);
  }
}

class Wall extends Thing {
  String toString() => "##";
}

class Gameboard {
  Gameboard(this.grid, this.width);

  factory Gameboard.parse(String filecont) {
    List<String> data = filecont.split('\n');
    int y = 0;
    int width = 0;
    List<List<Thing>> parsed = [];
    for (String line in data.toList()) {
      width = 0;
      //print("'" + line + "'");
      cols:
      for (String char in line.split('')) {
        switch (char) {
          case " ":
            parsed.add([]);
            break;
          case "#":
            parsed.add([Wall()]);
            break;
          case "v":
            parsed.add([Ball(Vec2(width, y), Vec2.south())]);
            break;
          case "s":
            parsed.add([Ball(Vec2(width, y), Vec2.south(), null, true)]);
            break;
          case ">":
            parsed.add([Ball(Vec2(width, y), Vec2.east())]);
            break;
          case "<":
            parsed.add([Ball(Vec2(width, y), Vec2.west())]);
            break;
          case "a":
            parsed.add([Ball(Vec2(width, y), Vec2.west(), null, true, 3)]);
            break;
          case "A":
            parsed.add([Ball(Vec2(width, y), Vec2.north())]);
            break;
          case "n":
            parsed.add([Ball(Vec2(width, y), Vec2.north(), null, true)]);
            break;
          default:
            throw FormatException(
                "Unexpected \"$char\"(${char.runes.first}) while parsing Gameboard");
        }
        width++;
      }
      y++;
    }
    //print("the W is $width");
    return Gameboard(
      parsed,
      width,
    );
  }

  final List<List<Thing>> grid;
  final int width;

  String toString() {
    String str = "";
    for(int i = 0; i < grid.length; i++) {
      if(i != 0 && i % width == 0) str += '\n';
      if(grid[i].length == 0) { str += "  "; continue;}
      if(grid[i].length == 1) str += "${grid[i].single}";//${grid[i].single}";
      else if(grid[i].whereType<Ball>().toList().length == 1) str += "${colors[grid[i].whereType<Ball>().toList().single.color]}XX\u001b[0m";
       else str += "XX"; 
    }
    return str;
  }

  /// Ticks the game
  void tick() {
    List<Ball> balls = grid
    .where(
      (List<Thing> things) => things.any(
        (Thing thing) => thing is Ball
      )
    )
    .expand(
      (List<Thing> things) => things.whereType<Ball>()
    )
    .toList();

    for(Ball ball in balls) {
      Ball newBall = ball.getUpdatedBall();
      if(!ball.generator) {
        grid[ball.position.dx + (ball.position.dy * width)].remove(ball);
      }
      if(ball.generator) {
        ball.genri = (ball.genri + 1) % ball.genl;
      }
      if(newBall.position.dy < 0) continue;
      if(newBall.position.dx >= width) continue;
      if(newBall.position.dx < 0) continue;
      if(newBall.position.dy >= grid.length / width) continue;
      if(ball.genri == 0) {
        grid[newBall.position.dx + (newBall.position.dy * width)].add(newBall);
      }
    }

    List<List<Thing>> collisions = grid.where((List<Thing> things) => things.length > 1).toList();

    for(List<Thing> things in collisions) {
      List<Thing> result = handleCollision(things).toList();
      things..clear()..addAll(result);
    }
  }
}

Iterable<Thing> handleCollision(List<Thing> things) sync* {
  if(things.length < 2) yield things[0];
  else {
  if(things.any((Thing thing) => thing is Wall || (thing as Ball).generator)) {
    for(Thing thing in things) {
      if(thing is Ball && !thing.generator) yield Ball(thing.position, -thing.velocity, thing.color); else yield thing;
    }
  } else {
    if(things.length > 2) {
      for(Thing thing in things) {
        if(thing is Ball) 
          yield Ball(thing.position, -thing.velocity, thing.color);
      }
    } else {
      if((things[0] as Ball).velocity == -(things[1] as Ball).velocity) {
        for(Thing thing in things) {
          if(thing is Ball && !thing.generator) 
            yield Ball(thing.position, -thing.velocity, thing.color, thing.generator);
        }
      } else {
        for(Thing ball in things) yield ball;
      }
    }
  }
  }
}

