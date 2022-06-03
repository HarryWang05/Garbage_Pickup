PVector landfill = new PVector(100,100);
Truck garbageTruck = new Truck(100,1.0,landfill);
Road starting;
int startIndex;
ArrayList<Road> roads = new ArrayList<Road>();
ArrayList<ArrayList<Road>> adjList = new ArrayList<ArrayList<Road>>();

void setup() {
  size(600,600);
  frameRate(30);
  roads.add(new Road(new PVector(100,100), new PVector(100,200), true));
  //garbageTruck.turn_left();
}

void draw() {
  background(127,255,0);
  fill(127,127,127);
  for(int i = 0; i < roads.size(); i++) {
    roads.get(i).pave();
  }
  fill(garbageTruck.paint);
  pushMatrix();
  translate(garbageTruck.loc.x,garbageTruck.loc.y);
  rotate(garbageTruck.direction);
  rect(0,0,10,20);
  popMatrix();
}
