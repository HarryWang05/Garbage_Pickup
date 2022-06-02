class Truck {
  PVector loc;
  float direction;
  int capacity;
  float speed;
  color paint;
  Truck(int capacity, float speed, PVector loc) {
    this.capacity = capacity;
    this.speed = speed;
    this.loc = loc;
    this.paint = color(0,127,0);
    this.direction = 0;
  }
  void turn_right() {
    direction += PI/4;
  }
  void turn_left() {
    direction -= PI/4;
  }
}
