class Road {
  int len;
  ArrayList<Integer> houses;
  Road(int len) {
    this.len = len;
    this.houses = new ArrayList<Integer>();
  }
  void addHouse(int houseLoc) {
    houses.add(houseLoc);
  }
}
