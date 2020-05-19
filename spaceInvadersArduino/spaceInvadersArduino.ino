// LED tests
int leftLED = 13;
int rightLED = 12;
// Tilt Sensor
int leftTILT = 11;
int rightTILT = 10;
// Tilt Reading
int leftTiltReading = 0;
int rightTiltReading = 0;
// Movement variable
int movement = 0;
// Button Sensor
int bulletButton = 6;
// Bullets Variable
int bullets;
// Bullet On and Off
int bulletReading = 0;
int prevBulletReading = 0;

void setup() {
  // put your setup code here, to run once
  //pinMode(leftLED, OUTPUT);
  //pinMode(rightLED, OUTPUT);
  pinMode(leftTILT, INPUT_PULLUP);
  pinMode(rightTILT, INPUT_PULLUP);
  pinMode(bulletButton, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  leftTiltReading = digitalRead(leftTILT);
  rightTiltReading = digitalRead(rightTILT);
  bulletReading = digitalRead(bulletButton);
  delay(50);
  if (bulletReading == 1 && prevBulletReading == 0) {
    bullets = 0;
  }
  // this is required because in processing the only way to shoot a single missile, is to shoot when bullets is equal to One 1
  // this way people can't cheat and hold the button for difficult spots
  if (bulletReading == 0 && prevBulletReading == 1 || bulletReading == 0 && prevBulletReading == 0) {
    bullets++;
  }
  prevBulletReading = bulletReading; // important for toggle
  if (rightTiltReading == 0 && leftTiltReading == 0 || rightTiltReading == 1 && leftTiltReading == 1) {
    //digitalWrite(leftLED, HIGH);
    //digitalWrite(rightLED, HIGH);
    movement += 0;
  }
  if (rightTiltReading == 1 && leftTiltReading == 0) {
    //digitalWrite(rightLED, HIGH);
    //digitalWrite(leftLED, LOW);
    if (movement >= 1870) {
      movement += 0;
    }
    else {
      movement += 20;
    }
  }
  if (rightTiltReading == 0 && leftTiltReading == 1) {
    //digitalWrite(leftLED, HIGH);
    //digitalWrite(rightLED, LOW);
    if (movement <= 0) {
      movement += 0;
    }
    else {
      movement -= 20;
    }
  }
  // The following way is the best way to do this
  Serial.print(movement);
  Serial.print(",");
  Serial.print(bullets);
  Serial.print(",");
  Serial.println();
  delay(50);
}
