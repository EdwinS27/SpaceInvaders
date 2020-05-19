class Missile {
  int missileX, missileY;
  final int missileRadius = 5;
  final int mSpeed = 5;
  boolean missileLifeSpan = false;
  boolean collision = false;
  Missile(int missX, int missY) {
    missileX = missX;
    missileY = missY;
  }
  // this code checks to see if the missile has reacged 
  boolean finished() {
    if (missileY == 0) {
      missileLifeSpan = true;
    } else {
      missileLifeSpan = false;
    }
    return missileLifeSpan;
  }
  void update() {
    missileY -= mSpeed;
    fill(255, 0, 0);
    circle(missileX, missileY, missileRadius);

    // check against Standard Enemy Class
    for (int i = enemies.size()-1; i >= 0; i--) {
      //grayson's code
      Enemy e = enemies.get(i);
      float dist = dist(e.enemyX, e.enemyY, missileX, missileY);
      if (dist < e.enemySize) {
        enemies.remove(i); //my code
        collision = true;
        enemies.add(new Enemy(enemyXSpawn, enemyYSpawn));
      }
    }
    //stronger enemy will go here
    for (int i = enemyBrute.size()-1; i >= 0; i--) {
      //grayson's code
      StrongerEnemy e = enemyBrute.get(i);
      float dist = dist(e.enemyX, e.enemyY, missileX, missileY-20);
      if (dist < e.enemySize) {
        e.lifePoints -=1;
        collision = true;
        if (e.lifePoints <= 0) {          
          enemyBrute.remove(i);
        }
      }
    }
    for (int i = enemyChargers.size()-1; i >= 0; i--) {
      //grayson's code
      ForwardEnemy e = enemyChargers.get(i);
      float dist = dist(e.enemyX, e.enemyY, missileX, missileY-20);
      if (dist < e.enemySize) {
        e.lifePoints -=1;
        collision = true;
        if (e.lifePoints <= 0) {          
          enemyChargers.remove(i);
        }
      }
    }
  }
}
