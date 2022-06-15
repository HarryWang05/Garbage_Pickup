class PairPVector {
  PVector x;
  PVector y;
  PairPVector(PVector x, PVector y) {
    this.x = x;
    this.y = y;
  }
  
  boolean setContains(HashSet<PairPVector> currentSet) {
    for(PairPVector it : currentSet) {
      if(it.same(this)) {
        return true;
      }
    }
    return false;
  }
  
  boolean same(PairPVector other) {
    if(x.equals(other.x) && y.equals(other.y)) {
      return true;
    }
    return false;
  }
}
