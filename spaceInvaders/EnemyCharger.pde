class ForwardEnemy {
  int enemyX;
  int enemyY;
  int yChange = 2;
  int lifePoints = 2;
  final int enemySize = 75;
  boolean removeMe = false;

  ForwardEnemy(int drawX, int drawY) {
    enemyX = drawX;
    enemyY = drawY;
  }
  void update() {    
    enemyY = enemyY + yChange;
    image(enemyShip, enemyX, enemyY, enemySize, enemySize-25);
  }
  boolean finished() {
    if (enemyY >= 1000) {
      removeMe = true;
    } else {
      removeMe = false;
    }
    return removeMe;
  }
}
