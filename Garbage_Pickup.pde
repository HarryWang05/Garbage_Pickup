import java.util.*;
import g4p_controls.*;

// Global variables
boolean running;
int currentCap;
int pathIndex;
int backTrack;
String whichFile = "roads.txt";

PVector landfill = new PVector(200, 200);
Truck garbageTruck = new Truck(2, landfill);
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

void setup() {
  size(600, 600);
  frameRate(1);
  createGUI();
  setLayout();
}

void draw() {
  // Pause if paused
  if(!running) {
    noLoop();
    return;
  }
  if(path == null) {
    render();
    println("Path could not be found");
    running = false;
    noLoop();
    return;
  }
  // Path is precalculated, changes route if capacity interferes
  if(currentCap < garbageTruck.capacity && backTrack == 0) {
    if(pathIndex < path.size()) {
      garbageTruck.turnGreen();
      garbageTruck.loc = path.get(pathIndex);
      pathIndex++;
      currentCap++;
      if(garbageTruck.loc.equals(landfill)) {
        currentCap = 0;
      }
    } else {
      for (int i = 0; i < path.size(); i++) {
        println(path.get(i));
      }
      println("DONE");
      noLoop();
    }
  } else if(currentCap == garbageTruck.capacity) {
    // Always follows current path. Although slightly inefficient, it works without fail
    garbageTruck.turnRed();
    backTrack++;
    garbageTruck.loc = path.get(pathIndex-backTrack);
    if(garbageTruck.loc.equals(landfill)) {
      currentCap = 0;
    }
  } else {
    garbageTruck.turnGreen();
    backTrack--;
    garbageTruck.loc = path.get(pathIndex-backTrack);
  }
  render();
}

// Find shortest path using depth-first-search
ArrayList<PVector> findPath(ArrayList<PVector> prev) {
  //HashSet<PVector> currentRoad = new HashSet<PVector>();
  ArrayList<PVector> hold;
  PairPVector currentRoad = new PairPVector();
  PVector current = prev.get(prev.size()-1);
  // Lenght of path is twice the amount of roads
  int size = roads.size()*2+1;
  // Base case, if path is already at proper size
  if (prev.size() == size) {
    return prev;
  }
  // DFS, try every possible direction
  for (int i = 0; i < intersections.get(current).size(); i++) {
    // Get start and end of road
    currentRoad.x = current;
    currentRoad.y = intersections.get(current).get(i);
    for(int j = 0; j < visitedRoads.size(); j++) {
      println(currentRoad,visitedRoads.get(j),visitedRoads.get(j).equals(currentRoad));
    }
    // If not in visited, move along road
    if(!currentRoad.arrayContains(visitedRoads)) {
      prev.add(intersections.get(current).get(i));
      visitedRoads.add(currentRoad);
      hold = findPath(prev);
      // If no possible path along that road
      if (hold == null) {
        prev.remove(prev.size()-1);
        continue;
      }
      // If path does not end on landfill
      if (!hold.get(hold.size()-1).equals(landfill)) {
        prev.remove(prev.size()-1);
        continue;
      }
      return hold;
    }
  }
  // Only returns null if no possible path
  return null;
}

// Setup the entire layout of a roads file
void setLayout() {
  intersections.clear();
  intersectionSet.clear();
  roads.clear();
  visitedRoads.clear();
  pathIndex = 0;
  currentCap = 0;
  backTrack = 0;
  newRoads = loadStrings(whichFile);
  boolean direct;
  String hold, first, second;
  int commaIndex;
  PVector pointOne;
  PVector pointTwo;
  // Creates roads based on txt file
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
  path = new ArrayList<PVector>();
  path.add(landfill);
  path = findPath(path);
}

// Render everything
void render() {
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
  circle(landfill.x, landfill.y, 40);
  fill(garbageTruck.paint);
  rectMode(CENTER);
  rect(garbageTruck.loc.x, garbageTruck.loc.y, 20, 20);
  rectMode(CORNER);
}
