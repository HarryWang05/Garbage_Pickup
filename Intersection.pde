class Intersection {
  ArrayList<Intersection> neighbours;
  PVector pos;
  Intersection(PVector pos) {
    this.pos = pos;
    this.neighbours = new ArrayList<Intersection>();
  }
}
