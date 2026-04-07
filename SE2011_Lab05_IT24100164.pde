// state system
int state = 0; 

//player
float px = 350, py = 250;
float vx = 0, vy = 0;

float accel = 0.6;
float friction = 0.9;
float gravity = 0.6;
float jumpForce = -12;

float pR = 20;

//No of Enemies
int n = 8;

float[] ex = new float[n];
float[] ey = new float[n];
float[] evx = new float[n];
float[] evy = new float[n];

float eR = 15;

//Game system
int lives = 3;

int startTime;
int duration = 30;

// cooldown
boolean canHit = true;
int lastHitTime = 0;
int cooldown = 800;

//setup
void setup() {
  size(700, 350);
  initEnemies();
}


void draw() {

  if (state == 0) drawStart();
  else if (state == 1) playGame();
  else if (state == 2) gameOver();
  else if (state == 3) winScreen();
}

//SWtart Screen
void drawStart() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("DODGE & SURVIVE", width/2, 120);
  textSize(16);
  text("Press ENTER to Start", width/2, 180);
}

//Game play
void playGame() {
  background(240);

  //Timer
  int timeLeft = duration - (millis() - startTime)/1000;

  if (timeLeft <= 0) state = 3;

  //Player Movement
  if (keyPressed) {
    if (keyCode == RIGHT) vx += accel;
    if (keyCode == LEFT)  vx -= accel;
  }

  vx *= friction;
  vy += gravity;

  px += vx;
  py += vy;

  //ground
  float ground = height - 40;
  if (py > ground) {
    py = ground;
    vy = 0;
  }

  //keep inside screen
  px = constrain(px, pR, width - pR);

  //draw player
  fill(60, 120, 255);
  ellipse(px, py, pR*2, pR*2);

  //Enemies
  for (int i = 0; i < n; i++) {

    ex[i] += evx[i];
    ey[i] += evy[i];

    if (ex[i] < eR || ex[i] > width - eR) evx[i] *= -1;
    if (ey[i] < eR || ey[i] > height - eR) evy[i] *= -1;

    fill(255, 80, 100);
    ellipse(ex[i], ey[i], eR*2, eR*2);

    // COLLISION
    float d = dist(px, py, ex[i], ey[i]);

    if (d < pR + eR && canHit) {
      lives--;
      canHit = false;
      lastHitTime = millis();
    }
  }

  //cooldown reset
  if (!canHit && millis() - lastHitTime > cooldown) {
    canHit = true;
  }

  //game over
  if (lives <= 0) state = 2;

  // UI
  fill(0);
  textSize(14);
  text("Lives: " + lives, 20, 20);
  text("Time: " + timeLeft, 20, 40);
}

//Game Over!!!
void gameOver() {
  background(0);
  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(30);
  text("GAME OVER", width/2, 150);
  textSize(16);
  text("Press R to Restart", width/2, 200);
}

//Win Screen
void winScreen() {
  background(0);
  fill(0, 255, 120);
  textAlign(CENTER);
  textSize(30);
  text("YOU WIN!", width/2, 150);
  textSize(16);
  text("Press R to Restart", width/2, 200);
}

//Key Input
void keyPressed() {

  //Start Game
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
    lives = 3;
  }

  //jump
  if (state == 1 && key == ' ' && vy == 0) {
    vy = jumpForce;
  }

  //Restart
  if ((state == 2 || state == 3) && (key == 'r' || key == 'R')) {
    resetGame();
  }
}

//Reset
void resetGame() {
  px = 350;
  py = 250;
  vx = 0;
  vy = 0;
  lives = 3;
  state = 0;
  initEnemies();
}

//Enemy setup
void initEnemies() {
  for (int i = 0; i < n; i++) {
    ex[i] = random(eR, width - eR);
    ey[i] = random(eR, height - eR);

    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);

    if (abs(evx[i]) < 1) evx[i] = 2;
    if (abs(evy[i]) < 1) evy[i] = -2;
  }
}
