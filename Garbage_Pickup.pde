import java.util.*;

boolean eulerian;
int startIndex;
int currentIndex;
int pathIndex;
PVector landfill = new PVector(200,200);
Truck garbageTruck = new Truck(100,1.0,landfill);
Road starting;
Road current;
Intersection startingPoint;
String[] newRoads;
ArrayList<Road> roads = new ArrayList<Road>();
ArrayList<ArrayList<Road>> adjList = new ArrayList<ArrayList<Road>>();
HashSet<PVector> intersectionSet = new HashSet<PVector>();
HashMap<PVector, ArrayList<PVector>> intersections = new HashMap<PVector, ArrayList<PVector>>();
ArrayList<PVector> path;

//Mouse fields
PVector clickCoord = new PVector();
PVector releaseCoord = new PVector();

void setup() {
  size(600,600);
  frameRate(1);
  newRoads = loadStrings("roads.txt");
  boolean direct;
  String hold,first,second;
  int commaIndex;
  PVector pointOne;
  PVector pointTwo;
  for(int i = 0; i < newRoads.length; i++) {
    hold = newRoads[i];
    commaIndex = hold.indexOf(',');
    first = hold.substring(0,commaIndex);
    second = hold.substring(commaIndex+1,hold.length());
    pointOne = new PVector(int(first),int(second));
    i++;
    hold = newRoads[i];
    commaIndex = hold.indexOf(',');
    first = hold.substring(0,commaIndex);
    second = hold.substring(commaIndex+1,hold.length());
    pointTwo = new PVector(int(first),int(second));
    i++;
    if(pointOne.x == pointTwo.x) {
      direct = false;
    } else if(pointOne.y == pointTwo.y) {
      direct = true;
    } else {
      println("Error reading roads.txt, no possible direction");
      break;
    }
    roads.add(new Road(pointOne, pointTwo, true));
  }
  //roads.add(new Road(new PVector(100,100), new PVector(100,200), true));
  roads.add(new Road(new PVector(100,200), new PVector(200,200), false));
  roads.add(new Road(new PVector(200,200), new PVector(200,100), true));
  roads.add(new Road(new PVector(200,100), new PVector(100,100), false));
  
  roads.add(new Road(new PVector(100,100), new PVector(0,100), false));
  roads.add(new Road(new PVector(0,100), new PVector(0,200), true));
  roads.add(new Road(new PVector(0,200), new PVector(100,200), false));
  
  roads.add(new Road(new PVector(100,200), new PVector(100,300), true));
  roads.add(new Road(new PVector(100,300), new PVector(200,300), false));
  roads.add(new Road(new PVector(200,300), new PVector(200,200), true));
  
  roads.add(new Road(new PVector(200,200), new PVector(300,200), false));
  roads.add(new Road(new PVector(300,200), new PVector(300,100), true));
  roads.add(new Road(new PVector(300,100), new PVector(200,100), false));
  
  roads.add(new Road(new PVector(200,100), new PVector(200,0), true));
  roads.add(new Road(new PVector(200,0), new PVector(100,0), false));
  roads.add(new Road(new PVector(100,0), new PVector(100,100), true));
  
  garbageTruck.loc = starting.start;
  current = starting;
  currentIndex = startIndex;
  eulerian = checkEulerian();
  /*for(Intersection it : intersections) {
    if(it.pos.equals(landfill)) {
      startingPoint = it;
      break;
    }
  }*/
  path = new ArrayList<PVector>();
  path.add(landfill);
  println(path);
  path = findPath(path);
  path.add(landfill);
  println(path);
}

void draw() {
  background(127,255,0);
  fill(127,127,127);
  for(int i = 0; i < roads.size(); i++) {
    roads.get(i).pave();
  }
  fill(127,127,127);
  rectMode(CENTER);
  for(PVector it : intersectionSet) {
    rect(it.x,it.y,20,20);
  }
  rectMode(CENTER);
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
  /*current = adjList.get(currentIndex).get(0);
  currentIndex = roads.indexOf(current);
  garbageTruck.loc = roads.get(currentIndex).start;*/
  if(pathIndex < path.size()) {
    garbageTruck.loc = path.get(pathIndex);
    pathIndex++;
  } else {
    for(int i = 0; i < path.size(); i++) {
      println(path.get(i));
    }
    println("YESS");
    noLoop();
  }
}

ArrayList<PVector> findPath(ArrayList<PVector> prev) {
  PVector current = prev.get(prev.size()-1);
  println(current);
  println(eulerian);
  int size;
  if(eulerian) {
    size = intersections.size();
  } else {
    size = intersections.size()+1;
  }
  if(prev.size() == size) {
    return prev;
  }
  println(intersections.get(current).size());
  for(int i = 0; i < intersections.get(current).size(); i++) {
    println("not ok");
    if(!prev.contains(intersections.get(current).get(i))) {
      println("ok");
      prev.add(intersections.get(current).get(i));
      ArrayList<PVector> hold;
      hold = findPath(prev);
      if(hold == null) {
        prev.remove(prev.size()-1);
        continue;
      }
      if(!intersections.get(prev.get(prev.size()-1)).contains(landfill)) {
        prev.remove(prev.size()-1);
        continue;
      }
      return hold;
    }
  }
  return null;
}

boolean checkEulerian() {
  for(PVector it : intersectionSet) {
    printArray(intersections.get(it).toArray());
    if(intersections.get(it).size()%2 == 1) {
      return false;
    }
  }
  return true;
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
