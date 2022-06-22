class Truck {
  // Fields
  PVector loc;
  int capacity;
  color paint;
  // Constructor
  Truck(int capacity, PVector loc) {
    this.capacity = capacity;
    this.loc = loc;
    this.paint = color(0,127,0);
  }
  void turnRed() {
    paint = color(127,0,0);
  }
  void turnGreen() {
    paint = color(0,127,0);
  }
}
