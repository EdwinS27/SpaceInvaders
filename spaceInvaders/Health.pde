class Health {
  int healthX;
  int healthY;
  final int healthSize = 25;
  boolean subtractALife = false;
  Health(int xPos, int ypos) {
    healthX = xPos;
    healthY = ypos;
  }
  void update() {
    fill(255, 0, 0);
    circle(healthX, healthY, healthSize);
    // 
    for (int i = enemies.size()-1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      // checks if the enemies have reached the end, if they have remove a life
      if (e.enemyY > 990) {
        // enemy has taken a life from me
        enemies.remove(i);
        subtractALife = true;
      }
    }
    for (int i = enemyBrute.size()-1; i >= 0; i--) {
      StrongerEnemy e = enemyBrute.get(i);
      // checks if the enemies have reached the end, if they have remove a life
      if (e.enemyY > 990) {
        // enemy has taken a life from me
        enemyBrute.remove(i);
        subtractALife = true;
      }
    }
    for (int i = enemyChargers.size()-1; i >= 0; i--) {
      ForwardEnemy e = enemyChargers.get(i);
      // checks if the enemies have reached the end, if they have remove a life
      if (e.enemyY > 990) {
        // enemy has taken a life from me
        enemyChargers.remove(i);
        subtractALife = true;
      }
    } // end of update
  } // end of class
}
