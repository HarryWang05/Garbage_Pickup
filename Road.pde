class Road {
  int len;
  boolean direction;
  PVector start;
  PVector end;
  ArrayList<Integer> houses;
  Road(int len, PVector start, PVector end) {
    this.len = len;
    this.houses = new ArrayList<Integer>();
    this.start = start;
    this.end = end;
  }
  void addHouse(int houseLoc) {
    houses.add(houseLoc);
  }
}
