class Truck {
  // Fields
  PVector loc;
  float direction;
  int capacity;
  color paint;
  // Constructor
  Truck(int capacity, PVector loc) {
    this.capacity = capacity;
    this.loc = loc;
    this.paint = color(0,127,0);
    this.direction = 0;
  }
  void turn() {
    direction -= PI/2;
  }
}
