PVector landfill = new PVector(100,100);
Truck garbageTruck = new Truck(100,1.0,landfill);

void setup() {
  size(600,600);
  frameRate(30);
  garbageTruck.turn_left();
}

void draw() {
  background(127,255,0);
  fill(garbageTruck.paint);
  pushMatrix();
  translate(garbageTruck.loc.x,garbageTruck.loc.y);
  rotate(garbageTruck.direction);
  rect(0,0,10,20);
  popMatrix();
}
