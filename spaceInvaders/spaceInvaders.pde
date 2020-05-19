// Importing Serial library & minim 
import processing.serial.*;
import ddf.minim.*;
Serial myPort; // Create object from Serial Class
String val; // This will be split
int movement; // Name of variable that will be split  
int bullets; // Name of variable that will be split
// Installing Minim
Minim minim;
AudioSample player;
AudioPlayer backgroundMusic;
// Images
PImage playerShip;
PImage enemyShip;
PImage deathStar;
// Menu variables
int menuState = 1; //keep track of what menu item is highlighted
int gameChoice = 0;
// star Variables
int starGenerator;
int starY = 0;
int starX;
// global variables in processing
boolean letMeOut = false;
int score; // score Variable
int posX; // the new variable for Ship when moved.
int lockedY = 1000; // locked Y variable for the Ship
// everything below is flexible
final int missileY = lockedY; // reference variable for the missiles' Y position.
int missileSY = missileY;
final int missileRadius = 5;
boolean gameplay = false;
boolean endgame = false;
// health variables
int numberOfLives = 1;
int healthX = 800;
int healthY = 25;
int healthSpacing = 50;
int healthCount;
// enemy variables
int enemyCount;
int enemyXSpawn = 0;
int enemyYSpawn = 50;
int chargerXSpawn;    
int bruteXSpawn;
int enemyGenerator;
final int enemySize = 25;
int defaultEnemyCount = 11;
final int enemySpacing = 100;
// creating an object array of missiles, enemies and health
ArrayList <Health> health = new ArrayList<Health>();
ArrayList <Missile> missiles = new ArrayList<Missile>();
ArrayList <Enemy> enemies = new ArrayList<Enemy>();
ArrayList <StrongerEnemy> enemyBrute = new ArrayList<StrongerEnemy>();
ArrayList <ForwardEnemy> enemyChargers = new ArrayList<ForwardEnemy>();
ArrayList <Stars> stars = new ArrayList<Stars>();
ArrayList <LittleStars> littleStars = new ArrayList<LittleStars>();

void setup() {
  fullScreen();
  frameRate(30);
  textSize(50);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  minim = new Minim(this);
  player = minim.loadSample("tieFighterBlast.mp3");
  playerShip = loadImage("playerShip.png");
  enemyShip = loadImage("xWingFighter.png");
  backgroundMusic = minim.loadFile("empireMusic.mp3");
  backgroundMusic.loop();
}

void draw() {
  background(0); // space background
  starX = int(random(0, 1920)); 
  starGenerator = int(random(0, 10000));
  starMaker();
  menuChoices();
  // when game starts begin the ability to spawn enemies
  if (gameplay == true) {
    chargerXSpawn = int(random(600, 1300));
    enemyGenerator = int(random(0, 10000)); 
    bruteXSpawn = int(random(1000, 1200)); // spawns an enemy at a random location in the map
    gameOn();
  } // end of gameplay
  gameOver();
  objectChecker(); // checks if objects have reached the end of their path or if they have been destroyed
  closeGame(); // closes the game when the menu option exit is selected
} // end of draw
void gameOn() {
  shipControls(); // if the game started you can begin using the controller
  enemySpawn();
  scoreKeeper();
  ship();
}
void ship() {
  image(playerShip, posX, lockedY-50, 100, 50);
}
// Score Keeper
void scoreKeeper() {
  fill(255);
  text("Current Score: "  + score, 500, 25);
}
// Cursor Location of the Menu
void cursorLocation() { // this is fine, don't touch
  if (menuState == 1) {
    fill(255);
    triangle(100, 375, 100, 425, 125, 400);
  }

  if (menuState == 2) {
    fill(255);
    triangle(100, 475, 100, 525, 125, 500);
  }

  if (menuState == 3) {
    fill(255);
    triangle(100, 575, 100, 625, 125, 600);
  }
}
// menuChoices can only see a menu when the game hasn't started or when its game over
void menuChoices() {
  // if game has started or its game over it will decide the menu choices.
  if (gameChoice == 0 || gameChoice == 4) {
    cursorLocation();
    menu();
  }
}
void menu() {
  if (gameChoice == 4) {
    // game over screen
    fill(255);
    text("GAME OVER \n Try Again?", width/2, 250);
    text("START EASY GAME", width/2, 400);
    text("START HARD GAME", width/2, 500);
    text("EXIT", width/2, 600);
  }
  if (menuState > 0 && gameChoice < 1) { 
    fill(255);
    text("GALAXY DEFENDERS", width/2-1, 299); //it requires 3 parameters, string, x-position, y-position
    text("GALAXY DEFENDERS", width/2, 300); //it requires 3 parameters, string, x-position, y-position
    text("START EASY GAME", width/2, 400);
    text("START HARD GAME", width/2, 500);
    text("EXIT", width/2, 600);
  }
  // after you lost
}
// Movement for the menu
void keyPressed() {
  // when you press up or down on the Keyboard
  if (gameplay == false) {
    if (keyCode == DOWN) {
      if (menuState < 4) {
        menuState = menuState + 1;
      }
      if (menuState > 3) {
        menuState = 1;
      }
    }
    if (keyCode == UP) {
      if (menuState > 0) {      
        menuState = menuState -1;
      }
      if (menuState < 1) {
        menuState = 3;
      }
    }
    // activate button
    if (key == ' ') {
      if (menuState == 3) {
        // this will exit the game
        gameChoice = 3;
        letMeOut = true;
        getMeOut();
      }
      score = 0;
      if (menuState == 2) {
        // this will activate Hard Game Mode
        gameChoice = 2;
        numberOfLives = 3;
        loadGame();
        gameplay = true;
      }
      if (menuState == 1) {
        // This will activate Easy Game Mode
        gameChoice = 1;
        numberOfLives = 5;
        loadGame();
        gameplay = true;
      }
      menuState = 1;
    }
  } // if the game is not active
} // Keypressed function
// starts the game
void shipControls() { // this is fine don't touch
  // will use this when the game starts and activates the arduino
  if (myPort.available() >0) {
    val = myPort.readStringUntil('\n');
    if (val != null) {
      String[] data = split(val, ',');
      if (data != null && data.length > 0) {
        //println("made it this far3");
        movement = int(data[0]);
        bullets = int(data[1]);
        posX = movement;
        if (bullets == 1) {
          missiles.add(new Missile(posX+50, missileSY));
          player.trigger();
        }
      }
    }
  }
} // shipControls function
void loadGame() { // this is fine don't touch
  // essentially setup() but moved to another function
  for (enemyCount = 0; enemyCount < defaultEnemyCount; enemyCount++) {
    enemies.add(new Enemy(enemyXSpawn, enemyYSpawn));
    enemyXSpawn = enemyXSpawn + enemySpacing;
  }
  for (healthCount = -1; healthCount < numberOfLives; healthCount++) {
    health.add(new Health(healthX, healthY));
    healthX = healthX + healthSpacing;
  }
} // load game function
void objectChecker() {
  // Checks to see if the missiles have collided with anything & if the missiles have reached the end of the path
  for (int i = missiles.size() - 1; i > 0; i--) {   
    Missile missile = missiles.get(i);
    missile.update();
    if (missile.finished()) {
      missiles.remove(i);
    }
    if (missile.collision == true) {      
      missiles.remove(i);
      score += 100;
    }
  }
  // checks to see if enemies have reached the end of their path to remove them from array list
  for (int spawnedEnemies = enemies.size() -1; spawnedEnemies > 0; spawnedEnemies--) {
    Enemy enemy = enemies.get(spawnedEnemies);
    enemy.update(); // moves the enemy
    if (enemy.finished()) {
      enemies.remove(spawnedEnemies); // checks if the enemies have reached the end of their path
    }
  }
  // checks to see the location of the chargers
  for (int bruteS = enemyBrute.size() -1; bruteS > 0; bruteS--) {
    StrongerEnemy enemy = enemyBrute.get(bruteS);
    enemy.update();
    if (enemy.finished()) {
      enemyBrute.remove(bruteS);
    }
  }
  // checks to see location of the chargers
  for (int chargers = enemyChargers.size() -1; chargers > 0; chargers--) {
    ForwardEnemy enemy = enemyChargers.get(chargers);
    enemy.update();
    if (enemy.finished()) {
      enemyChargers.remove(chargers);
    }
  }
  // checks to see how many lives are left
  for (int currentHealth = health.size() -1; currentHealth > 0; currentHealth--) {
    Health lives = health.get(currentHealth);
    lives.update();
    if (lives.subtractALife == true) {      
      health.remove(currentHealth);
      numberOfLives--;
      println(numberOfLives);
    }
  }
  // Checks to see if the Stars have reached the end of the screen
  for (int currentStars = stars.size() - 1; currentStars > 0; currentStars--) {   
    Stars shootingStars = stars.get(currentStars);
    shootingStars.update();
    if (shootingStars.finished()) {
      stars.remove(currentStars);
    }
  }
  for (int currentStar = littleStars.size() - 1; currentStar > 0; currentStar--) {   
    LittleStars smallStars = littleStars.get(currentStar);
    smallStars.update();
    if (smallStars.finished()) {
      littleStars.remove(currentStar);
    }
  }
}
// Close Game
void closeGame() {
  if (gameChoice == 3) {
    exit();
  }
}
void getMeOut() {
  if (letMeOut == true && gameChoice == 3) {
    exit();
  }
}
void gameOver() {
  if (numberOfLives == 0) {
    gameplay = false;
    gameChoice = 4;
    clearField();
    healthX = 800;
    enemyXSpawn = 0;
  }
}
void starMaker() {
  if (starGenerator < 10000 & starGenerator > 5000) {
    stars.add(new Stars(starX, starY));
  }
  if (starGenerator < 5000 & starGenerator > 0) {
    littleStars.add(new LittleStars(starX, starY));
  }
}
void enemySpawn() {  
  if ( enemyGenerator < 9900  && enemyGenerator > 9800 ) {
    // enemy Chargers are like common enemies, just travel in a different direction, but still not too many should appear
    enemyChargers.add(new ForwardEnemy(chargerXSpawn, enemyYSpawn));
  }
  if (enemyGenerator > 9980  && enemyGenerator < 9990) {
    // enemy Brutes are supposed to be rare, because too many will be unfair
    enemyBrute.add(new StrongerEnemy(bruteXSpawn, enemyYSpawn));
  }
}
void clearField() {
  // checks to see if enemies have reached the end of their path to remove them from array list
  for (int currentHealth = health.size() -1; currentHealth > -1; currentHealth--) {
    health.remove(currentHealth); // checks if the enemies have reached the end of their path
  }
  for (int spawnedEnemies = enemies.size() -1; spawnedEnemies > 0; spawnedEnemies--) {
    enemies.remove(spawnedEnemies); // checks if the enemies have reached the end of their path
  }
  // checks to see the location of the chargers
  for (int bruteS = enemyBrute.size() -1; bruteS > 0; bruteS--) {
    enemyBrute.remove(bruteS);
  }
  // checks to see location of the chargers
  for (int chargers = enemyChargers.size() -1; chargers > 0; chargers--) {
    enemyChargers.remove(chargers);
  }
}
