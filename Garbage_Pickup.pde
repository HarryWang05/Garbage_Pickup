import java.util.*;
import g4p_controls.*;

// Global variables
boolean running;
boolean eulerian;
int startIndex;
int currentIndex;
int pathIndex;
String whichFile = "roads.txt";

PVector landfill = new PVector(200, 200);
Truck garbageTruck = new Truck(100, landfill);
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
  createGUI();
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
  // Pause if paused
  if(!running) {
    noLoop();
    return;
  }
  // Path is precalculated, simply iterating through it
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
}

// Find shortest path using depth-first-search
ArrayList<PVector> findPath(ArrayList<PVector> prev) {
  //HashSet<PVector> currentRoad = new HashSet<PVector>();
  ArrayList<PVector> hold;
  PairPVector currentRoad = new PairPVector();
  PVector current = prev.get(prev.size()-1);
  // Lenght of path based on eulerian or not
  int size;
  if (eulerian) {
    size = roads.size()*2;
  } else {
    size = roads.size()*2+1;
  }
  // Base case, if path is already at proper size
  if (prev.size() == size) {
    return prev;
  }
  // DFS, try every possible direction
  for (int i = 0; i < intersections.get(current).size(); i++) {
    /*currentRoad.clear();
    currentRoad.add(current);
    currentRoad.add(intersections.get(current).get(i));*/
    // Get start and end of road
    currentRoad.x = current;
    currentRoad.y = intersections.get(current).get(i);
    for(int j = 0; j < visitedRoads.size(); j++) {
      println(currentRoad,visitedRoads.get(j),visitedRoads.get(j).equals(currentRoad));
    }
    // If not in visited, move along road
    if(!currentRoad.arrayContains(visitedRoads)) {
    //if (!visitedRoads.contains(currentRoad)) {
      prev.add(intersections.get(current).get(i));
      visitedRoads.add(currentRoad);
      hold = findPath(prev);
      // If no possible path along that road
      if (hold == null) {
        prev.remove(prev.size()-1);
        continue;
      }
      // If path does not end beside landfill
      if (!intersections.get(prev.get(prev.size()-1)).contains(landfill)) {
        prev.remove(prev.size()-1);
        continue;
      }
      return hold;
    }
  }
  // Only returns null if no possible path
  return null;
}

// Check if it is eulerian graph
boolean checkEulerian() {
  for (PVector it : intersectionSet) {
    // Allows sizes of 1 because the truck can go both ways of the road
    if (intersections.get(it).size()%2 == 1 && intersections.get(it).size() != 1) {
      return false;
    }
  }
  return true;
}

// Setup the entire layout of a roads file
void setLayout() {
  intersections.clear();
  intersectionSet.clear();
  roads.clear();
  visitedRoads.clear();
  newRoads = loadStrings(whichFile);
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
