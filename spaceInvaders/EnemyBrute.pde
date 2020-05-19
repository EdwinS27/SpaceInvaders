class StrongerEnemy {
  int enemyX;
  int enemyY;
  int yChange = 1;
  int lifePoints = 5;
  final int enemySize = 100;
  boolean offScreen = false;

  StrongerEnemy(int drawX, int drawY) {
    enemyX = drawX;
    enemyY = drawY;
  }
  void update() {    
    enemyY = enemyY + yChange;
    image(enemyShip, enemyX, enemyY, enemySize, enemySize-25);
  }
  boolean finished() {
    if (enemyY >= 1000) {
      offScreen = true;
    } else {
      offScreen = false;
    }
    return offScreen;
  }
}
