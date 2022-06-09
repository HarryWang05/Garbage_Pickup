import java.util.*;

boolean eulerian;
int startIndex;
int currentIndex;
PVector landfill = new PVector(100,100);
Truck garbageTruck = new Truck(100,1.0,landfill);
Road starting;
Road current;
String[] newRoads;
ArrayList<Road> roads = new ArrayList<Road>();
ArrayList<ArrayList<Road>> adjList = new ArrayList<ArrayList<Road>>();
HashSet<Intersection> intersections = new HashSet<Intersection>();
HashSet<Intersection> visited = new HashSet<Intersection>();
ArrayList<Intersection> path;

//Mouse fields
PVector clickCoord = new PVector();
PVector releaseCoord = new PVector();

void setup() {
  size(600,600);
  frameRate(1);
  newRoads = loadStrings("roads.txt");
  roads.add(new Road(new PVector(100,100), new PVector(100,200), true));
  roads.add(new Road(new PVector(100,200), new PVector(200,200), false));
  roads.add(new Road(new PVector(200,200), new PVector(200,100), true));
  roads.add(new Road(new PVector(200,100), new PVector(100,100), false));
  garbageTruck.loc = starting.start;
  current = starting;
  currentIndex = startIndex;
  path = findPath(new ArrayList<Intersection>());
}

void draw() {
  background(127,255,0);
  fill(127,127,127);
  for(int i = 0; i < roads.size(); i++) {
    roads.get(i).pave();
  }
  fill(127,127,127);
  for(Intersection it : intersections) {
    rectMode(CENTER);
    rect(it.pos.x,it.pos.y,20,20);
    rectMode(CORNER);
  }
  fill(127,127,255);
  circle(landfill.x,landfill.y,20);
  fill(garbageTruck.paint);
  //pushMatrix();
  //translate(garbageTruck.loc.x,garbageTruck.loc.y);
  //rotate(garbageTruck.direction);
  rectMode(CENTER);
  rect(garbageTruck.loc.x,garbageTruck.loc.y,20,20);
  rectMode(CORNER);
  //popMatrix();
  // Graph traversal
  /*if(current.direction != adjList.get(currentIndex).get(0).direction) {
    garbageTruck.turn();
  }*/
  current = adjList.get(currentIndex).get(0);
  currentIndex = roads.indexOf(current);
  garbageTruck.loc = roads.get(currentIndex).start;
}

ArrayList<Intersection> findPath(ArrayList<Intersection> prev) {
  Intersection current = prev.get(prev.size()-1);
  int size;
  if(eulerian) {
    size = intersections.size();
  } else {
    size = intersections.size()+1;
  }
  if(prev.size() == size) {
    return prev;
  }
  for(int i = 0; i < current.neighbours.size(); i++) {
    if(!visited.contains(current.neighbours.get(i))) {
      prev.add(current.neighbours.get(i));
      visited.add(current.neighbours.get(i));
      prev = findPath(prev);
      if(prev == null) {
        continue;
      }
      return prev;
    }
  }
  return null;
}

void mousePressed() {
  clickCoord.x = mouseX;
  clickCoord.y = mouseY;
  println(clickCoord);
}

void mouseReleased() {
  releaseCoord.x = mouseX;
  releaseCoord.y = mouseY;
  println(releaseCoord);
  roads.add(new Road(clickCoord,new PVector(releaseCoord.x,clickCoord.y),false));
}
