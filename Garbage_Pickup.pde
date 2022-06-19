import java.util.*;
import g4p_controls.*;

// Global variables
boolean eulerian;
int startIndex;
int currentIndex;
int pathIndex;

PVector landfill = new PVector(200, 200);
Truck garbageTruck = new Truck(100, 1.0, landfill);
Road starting;
Road current;

String[] newRoads;

// Data structures for intersections
ArrayList<PVector> path;
HashMap<PVector, ArrayList<PVector>> intersections = new HashMap<PVector, ArrayList<PVector>>();
HashSet<PVector> intersectionSet = new HashSet<PVector>();

// Data structures for roads
ArrayList<Road> roads = new ArrayList<Road>();
ArrayList<PairPVector> visitedRoads = new ArrayList<PairPVector>();
//ArrayList<HashSet<PVector>> visitedRoads = new ArrayList<HashSet<PVector>>();

void setup() {
  size(600, 600);
  frameRate(1);
  /*roads.add(new Road(new PVector(100,100), new PVector(100,200), true));
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
   roads.add(new Road(new PVector(300,200), new PVect`or(300,100), true));
   roads.add(new Road(new PVector(300,100), new PVector(200,100), false));
   
   roads.add(new Road(new PVector(200,100), new PVector(200,0), true));
   roads.add(new Road(new PVector(200,0), new PVector(100,0), false));
   roads.add(new Road(new PVector(100,0), new PVector(100,100), true));*/
  setLayout();
  //println(path);
  /*for(int i = 0; i < visitedRoads.size(); i++) {
    for(PVector it : visitedRoads.get(i)) {
      print(it);
    }
    println("|||");
  }*/
}

void draw() {
  background(127, 255, 0);
  fill(127, 127, 127);
  for (int i = 0; i < roads.size(); i++) {
    roads.get(i).pave();
  }
  fill(127, 127, 127);
  rectMode(CENTER);
  for (PVector it : intersectionSet) {
    rect(it.x, it.y, 20, 20);
  }
  rectMode(CENTER);
  fill(127, 127, 255);
  circle(landfill.x, landfill.y, 20);
  fill(garbageTruck.paint);
  //pushMatrix();
  //translate(garbageTruck.loc.x,garbageTruck.loc.y);
  //rotate(garbageTruck.direction);
  rectMode(CENTER);
  rect(garbageTruck.loc.x, garbageTruck.loc.y, 20, 20);
  rectMode(CORNER);
  //popMatrix();
  // Graph traversal
  /*if(current.direction != adjList.get(currentIndex).get(0).direction) {
   garbageTruck.turn();
   }*/
  /*current = adjList.get(currentIndex).get(0);
   currentIndex = roads.indexOf(current);
   garbageTruck.loc = roads.get(currentIndex).start;*/
  if (pathIndex < path.size()) {
    garbageTruck.loc = path.get(pathIndex);
    pathIndex++;
  } else {
    for (int i = 0; i < path.size(); i++) {
      println(path.get(i));
    }
    println("YESS");
    noLoop();
  }
}

ArrayList<PVector> findPath(ArrayList<PVector> prev) {
  //PairPVector currentRoad;
  //HashSet<PVector> currentRoad = new HashSet<PVector>();
  PairPVector currentRoad = new PairPVector();
  PVector current = prev.get(prev.size()-1);
  //println(current);
  //println(eulerian);
  int size;
  if (eulerian) {
    size = roads.size()*2;
  } else {
    size = intersections.size()+1;
  }
  if (prev.size() == size) {
    return prev;
  }
  for (int i = 0; i < intersections.get(current).size(); i++) {
    /*currentRoad.clear();
    currentRoad.add(current);
    currentRoad.add(intersections.get(current).get(i));*/
    currentRoad.x = current;
    currentRoad.y = intersections.get(current).get(i);
    for(int j = 0; j < visitedRoads.size(); j++) {
      println(currentRoad,visitedRoads.get(j),visitedRoads.get(j).equals(currentRoad));
    }
    if(!currentRoad.arrayContains(visitedRoads)) {
    //if (!visitedRoads.contains(currentRoad)) {
      prev.add(intersections.get(current).get(i));
      visitedRoads.add(currentRoad);
      ArrayList<PVector> hold;
      hold = findPath(prev);
      if (hold == null) {
        prev.remove(prev.size()-1);
        continue;
      }
      if (!intersections.get(prev.get(prev.size()-1)).contains(landfill)) {
        prev.remove(prev.size()-1);
        continue;
      }
      return hold;
    }
  }
  return null;
}

boolean checkEulerian() {
  for (PVector it : intersectionSet) {
    //printArray(intersections.get(it).toArray());
    if (intersections.get(it).size()%2 == 1) {
      return false;
    }
  }
  return true;
}

void setLayout() {
  intersections.clear();
  intersectionSet.clear();
  roads.clear();
  visitedRoads.clear();
  newRoads = loadStrings("roads.txt");
  boolean direct;
  String hold, first, second;
  int commaIndex;
  PVector pointOne;
  PVector pointTwo;
  for (int i = 0; i < newRoads.length; i++) {
    if (newRoads[i].charAt(0) == '#') {
      i++;
      continue;
    }
    hold = newRoads[i];
    if(hold.length() == 0) {
      println("Error reading roads.txt, empty string");
      break;
    }
    commaIndex = hold.indexOf(',');
    first = hold.substring(0, commaIndex);
    second = hold.substring(commaIndex+1, hold.length());
    pointOne = new PVector(int(first), int(second));
    i++;
    hold = newRoads[i];
    commaIndex = hold.indexOf(',');
    first = hold.substring(0, commaIndex);
    second = hold.substring(commaIndex+1, hold.length());
    pointTwo = new PVector(int(first), int(second));
    i++;
    if (pointOne.x == pointTwo.x) {
      direct = true;
    } else if (pointOne.y == pointTwo.y) {
      direct = false;
    } else {
      println("Error reading roads.txt, no possible direction");
      break;
    }
    roads.add(new Road(pointOne, pointTwo, direct));
  }
  garbageTruck.loc = landfill;
  current = starting;
  currentIndex = startIndex;
  eulerian = checkEulerian();
  path = new ArrayList<PVector>();
  path.add(landfill);
  //println(path);
  path = findPath(path);
  path.add(landfill);
}
