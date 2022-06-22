class Road {
  // Fields
  boolean direction;
  PVector start;
  PVector end;
  // Constructor
  Road(PVector start, PVector end, boolean direction) {
    this.start = start;
    this.end = end;
    this.direction = direction;
    // Adds intersections if they don't exist yet, and add neighbours to intersections
    if(!intersections.containsKey(this.start)) {
      intersections.put(this.start,new ArrayList<PVector>());
    }
    if(!intersections.containsKey(this.end)) {
      intersections.put(this.end,new ArrayList<PVector>());
    }
    intersections.get(this.start).add(this.end);
    intersections.get(this.end).add(this.start);
    intersectionSet.add(this.start);
    intersectionSet.add(this.end);
  }
  // Render roads
  void pave() {
    rectMode(CORNERS);
    if(direction) {
      rect(start.x-10,start.y,end.x+10,end.y);
    } else {
      rect(start.x,start.y-10,end.x,end.y+10);
    }
    rectMode(CORNER);
  }
}
