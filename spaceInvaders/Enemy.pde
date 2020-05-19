class Enemy {
  boolean removeMe = false;
  final int enemySize = 75;
  int xChange = -10;
  int yChange = 10;
  int enemyX;
  int enemyY;

  Enemy(int drawX, int drawY) {
    enemyX = drawX;
    enemyY = drawY;
  }
  void update() {    
    if (enemyX >= 1920) {
      enemyY = enemyY + yChange;
      xChange = xChange * -1;
    }
    if (enemyX <= 0) {
      enemyY = enemyY + yChange;
      xChange = xChange * -1;
    }
    enemyX = enemyX + xChange;
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
