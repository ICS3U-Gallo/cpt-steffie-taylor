boolean gameOver, roundOver;

int x, y;
int comX, comY;
int count;
int playWin, comWin;
int buttonColour;
float yMove, comSpeed, attackMove;

int round;

int comLife, playLife;

PVector[] comAttack;
PVector playLoc;
ArrayList<PVector> attack = new ArrayList <PVector>();

void setup() {
  size(800, 600);
  x = width*3/4;
  y = height-100;
  comX = width/8;
  comY = height-100;

  yMove = 0;
  comSpeed = 0;
  attackMove = 0;

  count = 0;
  round = 0;

  playWin = 0;
  comWin = 0;

  buttonColour = 255;

  comLife = 100;
  playLife = 100;

  gameOver = false;

  comAttack = new PVector[3];
  for (int i = 0; i < comAttack.length; i++) {
    float locX = comX + 50 ;
    float locY = comY + 50;
    comAttack[i] = new PVector(locX, locY);
  }
}

void draw() {
  background(128);
  y += yMove;
  comY += comSpeed;

  if (y >= height - 100 ) 
    yMove = 0;
  else if ( y < 300)
    yMove += 0.5; // gravity
  if (comY >= height - 100)
    comSpeed = 0;
  else if (comY < 300)
    comSpeed += 0.5;

  if (attack.size() > 3) {
    attack.remove(0);
  }
  
  
  if (round == 0) { //the display page before the game starts
    textSize(40);
    fill(0);
    text("Street Fighter", 280, 300);
    textSize (20);
    text("W, A, D for movement; \nHold J, K for attack.", width - 250, height - 100);
    fill(buttonColour);
    rect(280, 350, 280, 50);
    fill(0);
    textSize(20);
    text("Click to start", 350, 390);
    if (mousePressed) { //start the game when button is clicked
      if (mouseX >= 280 && mouseX <= 560 && mouseY <= 400 && mouseY >= 300)
        buttonColour = color(0, 255, 0);
    }
  }
  if (roundOver) { //reset the value if round ends
    x = width*3/4;
    y = 100;
    comX = width/8;
    comY = 100;

    comLife = 100;
    playLife = 100;
    roundOver = false;
  }
 
  if (!gameOver && !roundOver && round > 0) { 
    textSize(40);
    fill(0);
    text("Round: " + round, 40, 100 );

    if (keyPressed) { //player movement
      if (key == 'd' || key == 'D') {  // right
        x += 6;
      } 
      else if (key == 'a' || key == 'A') {  // left
        x -= 6;
      } 
      if (key == 'w' || key == 'W' ) { //jump
        if  (y >= 250 && y >= height - 100) 
          yMove = -10;
      }
      if (x < 0)
        x = 0;
      else if (x > width-100)
        x = width-100;
    }
    fill(255);
    rect(x, y, 100, 100); //drawPlayer
    fill(96);
    rect(x, y-10, 100, 5); //health bar
    fill(255, 0, 0);
    rect(x, y-10, playLife, 5);
    if (playLife <= 0) {
      roundOver = true;
      round++;
      comWin++;
    }

    fill(0); //drawComputer
    rect(comX, comY, 100, 100);
    fill(96); //health bar
    rect(comX, comY-10, 100, 5);
    fill(255, 0, 0);
    rect(comX, comY-10, comLife, 5);
    if (comLife <= 0) {
      roundOver = true;
      round++;
      playWin++;
    }
    if (round>3) //game over
      gameOver = true;

    if (comSpeed == 0) { 
      int comDefense = (int)random(20); //Computer movement
      if (comDefense % 2 == 0 && comDefense >= 10) {
        comX += 6;
      } else if (comDefense % 4 ==0 ) {
        comX -= 6;
      } else if (comDefense % 5 == 0 && attack.size() > 0) {
        comA();
      } else if (comDefense % 6 == 0 && attack.size() == 2 && comY == height - 100) {
        comSpeed = -15;
      }
      if (comX <= 0) {
        comX += 150;
      } else if (comX > width - 100) {
        comX -= 150;
      }
    }
    if (count > 0) { //movement of player attack
      fill(96);
      PVector loc = attack.get(count-1);
      loc.x += attackMove;
      ellipse(loc.x, loc.y, 10, 10);
      if (loc.x >= comX - 50 && loc.x <= comX + 50 && loc.y <= comY + 100 && loc.y >= comY - 100) {
        fill(255, 0, 0);
        rect(comX, comY, 100, 100);
        comX -= 10;
        comLife -= 5;
        attack.remove(0);
        count --;
      }
      else if (loc.x < 0 || loc.x > width) {
        attack.remove(0);
        count -- ;
      }
    }
    
    if (keyPressed && count <= 3) { //player attack
      if (key == 'j' || key == 'J') {
        playLoc = new PVector(x - 50, y + 50);
        attack.add(playLoc);
        count ++;
        attackMove = 0 - 10;
      }
      else if (key == 'k' || key == 'K') {
        playLoc = new PVector (x + 50, y + 50);
        attack.add(playLoc);
        count++;
        attackMove = 10;
      }
      if (count > 3) { 
        count = 0;
      }
    }
  }
  if (gameOver) {
    if (comWin > playWin) {
      textSize(20);
      fill(255);
      text("Computer wins", 300, 300);
      text(comWin + ":" + playWin, 300, 350);
      fill(0);
      rect(comX, comY, 100, 100);
    } else {
      textSize(20);
      fill(255);
      text("You win", 300, 300);
      text(playWin + ":" + comWin, 300, 350);
      fill(255);
      rect(x, y, 100, 100);
    }
    fill(buttonColour);
    rect(280, 350, 280, 50);
    textSize(20);
    fill(96);
    text("Try again", 350, 390);
   if(mousePressed) { 
      if (mouseX >= 280 && mouseX <= 560 && mouseY <= 400 && mouseY >= 300)
      buttonColour = color(0, 255, 0);
      round = 0;
      gameOver = false;
   }
  }
}

void comA() { //computer attack 
  for (int i = 0; i < comAttack.length; i++) {
    fill(117, 0, 0);
    ellipse(comAttack[i].x, comAttack[i].y, 10, 10);
    if (comAttack[i].x < x - 50) { 
      comAttack[i].x += 15;
    } else if (comAttack[i].x > x + 50) {
      comAttack[i].x -= 15;
    } else if (comAttack[i].x >= x - 50 && comAttack[i].x <= x +50  && comAttack[i].y <= y+50 && comAttack[i].y >= y -50) {
      playLife -= 5;
      x += 15;
      fill(255, 0, 0);
      rect(x, y, 100, 100);
      comAttack[i].x = comX + 100;
      i -- ;
    } else if (comAttack[i].x <= 0 || comAttack[i].x >= width) {
      comAttack[i].x = comX + 50;
      i -- ;
    }
  }
}

void mouseReleased() {
  if (round == 0 ) {
    if (mouseX >= 280 && mouseX <= 560 && mouseY <= 400 && mouseY >= 300)
      round = 1;
      buttonColour = 255;
  }
}
