class Road {
  boolean direction;
  PVector start;
  PVector end;
  ArrayList<Integer> houses;
  Road(PVector start, PVector end, boolean direction) {
    boolean exists;
    this.houses = new ArrayList<Integer>();
    this.start = start;
    this.end = end;
    this.start.x += 100;
    this.start.y += 100;
    this.end.x += 100;
    this.end.y += 100;
    this.direction = direction;
    adjList.add(new ArrayList<Road>());
    if(this.start.equals(landfill)) {
      starting = this;
      startIndex = adjList.size()-1;
    }
    for(int i = 0; i < roads.size(); i++) {
      if(roads.get(i).end.equals(this.start)) {
        //Add the road being created to the road's adjList index
        adjList.get(i).add(this);
      }
      if(roads.get(i).start.equals(this.end)) {
        //Add the road to the adjList index of the road being created
        adjList.get(adjList.size()-1).add(roads.get(i));
      }
    }
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
    /*Intersection starter = new Intersection(this.start);
    Intersection ender = new Intersection(this.end);
    exists = false;
    for(Intersection it : intersections) {
      if(it.pos.equals(starter.pos)) {
        it.neighbours.add(ender);
        exists = true;
        break;
      }
    }
    if(!exists) {
      starter.neighbours.add(ender);
      intersections.add(starter);
    }
    exists = false;
    for(Intersection it : intersections) {
      if(it.pos.equals(ender.pos)) {
        it.neighbours.add(starter);
        exists = true;
        break;
      }
    }
    if(!exists) {
      ender.neighbours.add(starter);
      intersections.add(ender);
    }*/
  }
  void addHouse(int houseLoc) {
    houses.add(houseLoc);
  }
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
