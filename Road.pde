class Road {
  boolean direction;
  PVector start;
  PVector end;
  ArrayList<Integer> houses;
  Road(PVector start, PVector end, boolean direction) {
    this.houses = new ArrayList<Integer>();
    this.start = start;
    this.end = end;
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
