class LittleStars {
  int starX;
  int starY;
  int yChange = 5;
  boolean removeMe = false;
  final int starSize = 2;

  LittleStars(int drawX, int drawY) {
    starX = drawX;
    starY = drawY;
  }
  void update() {    
    starY = starY + yChange;
    fill(255, 255, 0);
    circle(starX, starY, starSize);
  }
  boolean finished() {
    if (starY >= 1000) {
      removeMe = true;
    } else {
      removeMe = false;
    }
    return removeMe;
  }
}
