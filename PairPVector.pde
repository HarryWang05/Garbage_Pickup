class PairPVector {
  //Fields
  PVector x;
  PVector y;
  
  // Constructor 1
  PairPVector() {
    this.x = new PVector();
    this.y = new PVector();
  }
  
  // Constructor 2
  PairPVector(PVector x, PVector y) {
    this.x = x;
    this.y = y;
  }
  
  //Needs own contains method because uses own 'same' method
  boolean arrayContains(ArrayList<PairPVector> currentSet) {
    for(PairPVector it : currentSet) {
      if(it.same(this)) {
        return true;
      }
    }
    return false;
  }
  
  // Checks if two PairPVectors are equal, equals() does not work for this class
  boolean same(PairPVector other) {
    if(x.equals(other.x) && y.equals(other.y)) {
      return true;
    }
    return false;
  }
  
  // This makes this class printable
  @Override
  String toString() {
    // Looks like [100.0,100.0],[200.0,200.0]
    return "["+String.valueOf(this.x.x)+','+String.valueOf(this.x.y)+"],["+String.valueOf(this.y.x)+','+String.valueOf(this.y.y)+"]";
  }
}
