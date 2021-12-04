final int cooldownRemaining = 0, maxCooldown = 1, towerVision = 2, projectileType = 3;
ArrayList<int[]> towerData;

int[] towerVisions = {
  //EDIT CODE HERE TO GIVE VALUES
  200, 
  150, //eight-shot tower
  250, //slow tower
  125
};

color[] towerColours = {
  //EDIT COLOURS HERE
  #7b9d32, 
  #ff86dd, //eight-shot tower
  #86faff, //slow tower
  #96ff98 //lightning tower
};


int[] towerPrice = {
  //EDIT PRICES HERE
  100, 
  150, //eight-shot tower
  125, //slow tower
  450 // lightning tower
};

int[] makeTowerData(int towerID) {  
  if (towerID == def) {
    return new int[] {
      10, // Cooldown between next projectile
      10, // Max cooldown
      towerVisions[def], // Tower Vision
      0 // Projectile ID
    };
  } else if (towerID == eight) {
    return new int[] {
      20, 
      20, 
      towerVisions[eight], 
      1
    };
  } else if (towerID == slow) {
    return new int[] {
      15, 
      30, 
      towerVisions[slow], 
      2
    };
  } else if (towerID == lightning) {
    return new int[] {
      15, 
      20, 
      towerVisions[lightning], 
      3
    };
  }
  return new int[] {}; //filler since we need to return something
}

// ***DON'T GO BEYOND HERE, NO NEED TO CHANGE CODE HERE***

// --------------------------------------------------

// Draw a simple tower at a specified location
void drawTowerIcon(float xPos, float yPos, color colour) {
  strokeWeight(0);
  stroke(0);
  fill(colour);
  rectMode(CENTER);
  rect(xPos, yPos, towerSize, towerSize); // Draw a simple rectangle as the tower
}

// Draws a tower that rotates to face the targetLocation
void drawTowerWithRotation(float xPos, float yPos, color colour, PVector targetLocation) {
  pushMatrix();
  translate(xPos, yPos);

  // Angle calculation
  float slope = (targetLocation.y - yPos) / (targetLocation.x - xPos);
  float angle = atan(slope);

  rotate(angle);

  strokeWeight(0);
  fill(colour);
  rectMode(CENTER);
  rect(0, 0, towerSize, towerSize); // Draw a simple rectangle as the tower

  popMatrix();
}

void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    int[] data = towerData.get(i);
    int towerType = data[projectileType];
    PVector track = track(towers.get(i), data[towerVision]);
    if (track == null) {
      drawTowerIcon(xPos, yPos, towerColours[towerType]);
    } else {
      drawTowerWithRotation(xPos, yPos, towerColours[towerType], new PVector(track.x, track.y));
    }
    if (pointRectCollision(mouseX, mouseY, xPos, yPos, towerSize)) {
      // Drawing the tower range visually 
      fill(127, 80);
      stroke(127);
      strokeWeight(4);
      ellipseMode(RADIUS);
      ellipse(xPos, yPos, data[towerVision], data[towerVision]);
    }
    fill(#4C6710);
    textSize(12);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}

void drawSelectedTowers() {
  // Draws the tower you're dragging
  // Changing the color if it is an illegal drop to red
  // Loops through the three towerIDs and checks each if any of them are currently being dragged
  // Note that more than one tower can be dragged at a time
  for (int towerID = 0; towerID < towerCount; towerID++) {
    if (held[towerID]) {
      PVector location = dragAndDropLocations[towerID];
      if (!legalDrop(towerID)) {
        drawTowerIcon(location.x, location.y, #FF0000);
      } else {
        drawTowerIcon(location.x, location.y, towerColours[towerID]);
      }
      // Drawing the tower range of the selected towers 
      fill(127, 80);
      stroke(127);
      strokeWeight(4);
      ellipseMode(RADIUS);
      ellipse(location.x, location.y, towerVisions[towerID], towerVisions[towerID]);
    }
  }
  // Draws the default towers
  for (int towerType = 0; towerType < towerCount; towerType++) {
    PVector location = originalLocations[towerType];
    if (attemptingToPurchaseTowerWithoutFunds(towerType)) {
      drawTowerIcon(location.x, location.y, towerErrorColour);
    } else drawTowerIcon(location.x, location.y, towerColours[towerType]);
    fill(255);
    textSize(14);
    int textOffsetX = -15, textOffsetY = 26;
    // displays the prices of towers
    text("$" + towerPrice[towerType], location.x + textOffsetX, location.y + textOffsetY);
  }
}

int wave = 1;

import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
// Program main method
void setup() {
  size(800, 500);
  loadHeartIcon();
  initDragAndDrop();
  initPath();
}


ArrayList<float[]> balloons = new ArrayList<float[]>();
final int distanceTravelled = 0, delay = 1, type = 2, hp = 3, slowed = 4, ID = 5;
final int balloonRadius = 25; //Radius of the balloon
final int[] maxBalloonHP = {0, 10, 20, 40, 60, 80};
final color[] balloonColors = {#000000, #ff3d36, #368fff, #07f230, #ffeb31, #ff55e3};
final color[] slowedBalloonColors = {#000000, #ff8080, #98c7ff, #a7f0b3, #fff598, #ffaaf1};

int balloonType;
final int redBalloon = 1, blueBalloon = 2, greenBalloon = 3, yellowBalloon = 4, pinkBalloon = 5, totalBalloonColors = 5;


// making each wave
void createWave(int waveNum) {
  //{Number of "steps" taken, frames of delay before first step, speed, hp, slowed (0=no, 1=yes)}
  
  // wave 1
  // 10 30-spaced red balloons
  
  if (waveNum == 1) {
    for (int i = 0; i < 10; i++) {
      balloonType = redBalloon;
      balloons.add(new float[]{0, i * 30 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
    

  // wave 2
  // 25 10-grouped red balloons

  } else if (waveNum == 2) {
    for (int i = 0; i < 25; i++) {
      balloonType = redBalloon;
      balloons.add(new float[]{0, i * 10 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 3
  // 15 20-spaced blue balloons
  
  } else if (waveNum == 3) {
    for (int i = 0; i < 15; i++) {
      balloonType = blueBalloon;
      balloons.add(new float[]{0, i * 20 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 4
  // 20 15-grouped blue balloons, 30 10-grouped red balloons
  
  } else if (waveNum == 4) {
    for (int i = 0; i < 35; i++) {
      balloonType = blueBalloon;
      balloons.add(new float[]{0, i * 10 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  } else if (waveNum == 8) {
    for (int i = 0; i < 35; i++) {
      balloonType = greenBalloon;
      balloons.add(new float[]{0, i * 15 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  } else if (waveNum == 9) {
    for (int i = 0; i < 15; i++) {
      balloonType = yellowBalloon;
      balloons.add(new float[]{0, i * 20 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  } else if (waveNum == 10) {
    for (int i = 0; i < 35; i++) {
      balloonType = greenBalloon;
      balloons.add(new float[]{0, i * 5 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
    for (int i = 0; i < 20; i++) {
      balloonType = yellowBalloon;
      balloons.add(new float[]{0, i * 15 + 200, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  } else {
    int rand, rand2, rand3;
    for (int i = 0; i < ((wave + 1)/3); i++) {
      rand = (int)random(1, min(totalBalloonColors, wave/3 + 1)); // random balloon type (color)
      balloonType = rand;

      rand2 = (int)random(2, 6); // number of balloons

      rand3 = (int)random(1, 5); // spacing between balloons

      for (int j = 0; j < rand2 * 5; j++) {
        balloons.add(new float[]{0, (i * rand2 * rand3 * 14) + j * rand3*5 + 20, balloonType + 1, maxBalloonHP[balloonType], 0, (rand2 * i) + j});
      }
    }
  }
  
  
  println("WAVE " + wave);
  wave += 1;
}


void draw() {
  background(#add558);
  drawPath();

  drawAllTowers(); // Draw all the towers that have been placed down before
  drawTrash();
  drawSelectedTowers();
  dragAndDropInstructions();

  drawBalloons();
  handleProjectiles();
  drawHealthBar();
  drawBalanceDisplay();

  if (health <= 0) {
    drawLostAnimation();
  }

  if (balloons.size() == 0) {
    fill(#40CB68);
    rectMode(CORNER);
    rect(20, 420, 80, 60);
    if (clickNext) {
      clickNext = false;
      createWave(wave);
    }
  } else {
    fill(#add558);
    noStroke();
    rectMode(CORNER);
    rect(20, 420, 80, 60);
  }
}

// Whenever the user drags the mouse, update the x and y values of the tower
void mouseDragged() {
  if (currentlyDragging != notDragging) {
    dragAndDropLocations[currentlyDragging] = new PVector(mouseX + difX, mouseY + difY);
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  for (int i = 0; i < towerCount; i++) {
    handlePickUp(i);
  }
}

boolean clickNext = false;
boolean hoverNextWave(int x, int y) {
  return (x >= 20 && x <= 100 && y >= 420 && y <= 480);
}

// Whenever the user releases their mouse
void mouseReleased() {
  if (currentlyDragging != notDragging) {
    handleDrop(currentlyDragging);
  }
  currentlyDragging = notDragging;
  if (hoverNextWave(mouseX, mouseY)) {
    clickNext = true;
  }
}


/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
 */

// Displays and moves balloons
void updatePositions(float[] balloon) {
  // Only when balloonProps[1] is 0 (the delay) will the balloons start moving.
  if (balloon[delay] == 0) {

    PVector position = getLocation(balloon[distanceTravelled]);
    float travelSpeed = balloon[type];
    balloon[distanceTravelled] += travelSpeed; //Increases the balloon's total steps by the speed

    //Drawing of ballon
    ellipseMode(CENTER);
    strokeWeight(0);
    stroke(0);
    fill(0);

    //draw healthbar outline
    stroke(0, 0, 0);
    strokeWeight(0);
    rectMode(CORNER);
    fill(#830000);
    final float hbLength = 35, hbWidth = 6;
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength, hbWidth);
    //draw mini healthbar
    noStroke();
    fill(#FF3131);
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength * (balloon[hp] / maxBalloonHP[(int)balloon[type]-1]), hbWidth); //the healthbar that changes based on hp

    noFill();

    //write text
    stroke(0, 0, 0);
    textSize(14);
    fill(255, 255, 255);
    text("Health:   "+health, 670, 462);

    fill(balloonColors[(int)balloon[type]-1]);
    if (balloon[slowed] == 1) {
      fill(slowedBalloonColors[(int)balloon[type]]);
    }
    ellipse(position.x, position.y, balloonRadius, balloonRadius);
  } else {
    balloon[delay]--;
  }
}

void drawBalloons() {
  for (int i = 0; i < balloons.size(); i++) {
    float[] balloon = balloons.get(i);
    updatePositions(balloon);
    if (balloon[hp] <= 0) {
      handleBalloonPop();
      balloons.remove(i);
      i--;
      continue;
    }
    if (atEndOfPath(balloon[distanceTravelled])) {
      balloons.remove(i); // Removing the balloon from the list
      health--; // Lost a life.
      i--; // Must decrease this counter variable, since the "next" balloon would be skipped
      // When you remove a balloon from the list, all the indexes of the balloons "higher-up" in the list will decrement by 1
    }
  }
}

// Similar code to distance along path
boolean atEndOfPath(float travelDistance) {
  float totalPathLength = 0;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    float distance = dist(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    totalPathLength += distance;
  }
  if (travelDistance >= totalPathLength) return true; // This means the total distance travelled is enough to reach the end
  return false;
}

// ------- HP SYSTEM --------
/*
  Heath-related variables:
 int health: The player's total health.
 This number decreases if balloons pass the end of the path (offscreen), currentely 11 since there are 11 balloons.
 PImage heart: the heart icon to display with the healthbar.
 */
int health = 11;  //variable to track user's health
PImage heart;

void loadHeartIcon() {
  heart = loadImage("heart.png");
}
//method to draw a healthbar at the bottom right of the screen
void drawHealthBar() {
  //draw healthbar outline
  stroke(0, 0, 0);
  strokeWeight(0);
  fill(#830000);
  rectMode(CENTER);
  rect(721, 455, 132, 20);

  //draw healthbar
  noStroke();
  rectMode(CORNER);
  fill(#FF3131);
  rect(655, 445.5, Math.max(0, health*12), 20); //the healthbar that changes based on hp
  rectMode(CENTER);
  noFill();

  //write text
  stroke(0, 0, 0);
  textSize(14);
  fill(255, 255, 255);
  text("Health:   "+health, 670, 462);

  // //  put the heart.png image on screen
  //imageMode(CENTER);
  //  image(heart, 650, 456);
  noFill();
}
/** Currency system for tower defense
 *  - Rewards player for popping balloon
 *  - Keeps track of balance
 *  - Checks for sufficient funds when purchasing tower
 */

// Current amount of money owned by the player
int currentBalance = 750; // Give the user $750 of starting balance
final int rewardPerBalloon = 15; // Money earned by popping a balloon

void handleBalloonPop() {
  // Reward the player for popping the balloon
  increaseBalance(rewardPerBalloon);
}


void increaseBalance(int amount) {
  currentBalance += amount; // Increase the current balance by the amount given
}


/** Checks to see if there is sufficient balance for purchasing a certain item
 *  Parameter "cost" is the cost of the tower to be purchased
 */
boolean hasSufficientFunds(int cost) {
  if (currentBalance < cost) {
    return false; // Not enough money to purchase the tower
  } else {
    return true; // Enough money to purchase the tower
  }
}

/** Purchases a tower
 *  Parameter "cost" is the cost of the tower to be purchased
 */
void purchaseTower(int cost) {
  currentBalance -= cost;
}

// Checks to see if the user is attempting to purchase/pick up a tower but has insufficient funds
boolean attemptingToPurchaseTowerWithoutFunds(int towerID) {
  if (mousePressed && withinBounds(towerID) && !hasSufficientFunds(towerPrice[towerID])) {
    return true;
  } else {
    return false;
  }
}

// Displays the user's current balance on the screen
void drawBalanceDisplay() {
  // If the user is attempting to purchase a tower without funds, warn them with red display text
  boolean error = false;
  for (int i = 0; i < towerCount; i++) {
    if (attemptingToPurchaseTowerWithoutFunds(i)) {
      error = true;
    }
  }
  if (error) {
    fill(towerErrorColour);
  } else {
    fill(0); // Black text
  }

  text("Current Balance: $" + currentBalance, 336, 65);
}
/*
Encompasses: Displaying Towers, Drag & Drop, Discarding Towers, Rotating Towers, Tower Validity Checking
 */
// -------- CODE FOR DRAG & DROP ----------------------

int currentlyDragging = -1; // -1 = not holding any tower, 0 = within default, 1 = within eight, 2 = within slow, 3 = within lightning
final int notDragging = -1;
final int def = 0, eight = 1, slow = 2, lightning = 3;
final int towerCount = 4;
int difX, difY, count;

boolean[] held = {false, false, false, false};
PVector[] originalLocations = {new PVector(600, 50), new PVector(650, 50), new PVector(700, 50), new PVector(750, 50)}; // Constant, "copy" array to store where the towers are supposed to be
PVector[] dragAndDropLocations = {new PVector(600, 50), new PVector(650, 50), new PVector(700, 50), new PVector(750, 50)}; // Where the currently dragged towers are

ArrayList<PVector> towers; // Towers that are placed down


final int towerSize = 25;
final color towerErrorColour = #E30707; // Colour to display when user purchases tower without sufficient funds
//final color 
//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

void initDragAndDrop() {
  difX = 0;
  difY = 0;

  trashX1 = 525;
  trashY1 = 30;
  trashX2 = 775;
  trashY2 = 120;

  count = 0;
  towers = new ArrayList<PVector>();
  towerData = new ArrayList<int[]>();
}

// Use point to rectangle collision detection to check for mouse being within bounds of pick-up box
boolean pointRectCollision(float x1, float y1, float x2, float y2, float size) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= size / 2) && (abs(y2 - y1) <= size / 2);
}

boolean withinBounds(int towerID) {
  PVector towerLocation = dragAndDropLocations[towerID];
  return pointRectCollision(mouseX, mouseY, towerLocation.x, towerLocation.y, towerSize);
}

//check if you drop in trash
boolean trashDrop(int towerID) {
  PVector location = dragAndDropLocations[towerID];
  if (location.x >= trashX1 && location.x <= trashX2 && location.y >= trashY1 && location.y <= trashY2) return true;
  return false;
}

// -------Methods Used for further interaction-------
void handleDrop(int towerID) { // Will be called whenever a tower is placed down
  // Instructions to check for valid drop area will go here
  if (trashDrop(towerID)) {
    dragAndDropLocations[towerID] = originalLocations[towerID];
    held[towerID] = false;
    println("Dropped object in trash.");
  } else if (legalDrop(towerID)) {
    towers.add(dragAndDropLocations[towerID].copy());
    towerData.add(makeTowerData(towerID));
    dragAndDropLocations[towerID] = originalLocations[towerID];
    held[towerID] = false;
    purchaseTower(towerPrice[towerID]);
    println("Dropped for the " + (++count) + "th time.");
  }
}

// Will be called whenever a tower is picked up
void handlePickUp(int pickedUpTowerID) {
  if (withinBounds(pickedUpTowerID) && hasSufficientFunds(towerPrice[pickedUpTowerID])) {
    currentlyDragging = pickedUpTowerID;
    held[currentlyDragging] = true;
    PVector location = dragAndDropLocations[pickedUpTowerID];
    difX = (int) location.x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = (int) location.y - mouseY;
  }
  println("Object picked up.");
}

void drawTrash() {
  rectMode(CORNERS);
  noStroke();
  fill(#4C6710);
  rect(trashX1, trashY1, trashX2, trashY2);
  fill(255, 255, 255);
  stroke(255, 255, 255);
}

void dragAndDropInstructions() {
  fill(#4C6710);
  textSize(12);

  text("Pick up tower from here!", 620, 20);
  text("You can't place towers on the path of the balloons!", 200, 20);
  text("Place a tower into the surrounding area to put it in the trash.", 200, 40);
  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + mousePressed + "\nTower Held: " + currentlyDragging + "\n\nWave: " + (wave-1) + "\nBalloons left: " + balloons.size(), 15, 20);
}


// -------- CODE FOR PATH COLLISION DETECTION ---------

float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  float t = max(0, min(1, PVector.sub(point, start).dot(PVector.sub(end, start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end, start), t));  // Projection falls on the segment
  return dist(point.x, point.y, projection.x, projection.y);
}

float shortestDist(PVector point) {
  float answer = Float.MAX_VALUE;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector start = points.get(i);
    PVector end = points.get(i + 1);
    float distance = pointDistToLine(start, end, point);
    answer = min(answer, distance);
  }
  return answer;
}

// Will return if a drop is legal by looking at the shortest distance between the rectangle center and the path.
boolean legalDrop(int towerID) {
  PVector heldLocation = dragAndDropLocations[towerID];
  // checking if this tower overlaps any of the already placed towers
  for (int i = 0; i < towers.size(); i++) {
    PVector towerLocation = towers.get(i);
    if (pointRectCollision(heldLocation.x, heldLocation.y, towerLocation.x, towerLocation.y, towerSize)) return false;
  }
  return shortestDist(heldLocation) > PATH_RADIUS;
}
int framesSinceLost = 0;
void drawLostAnimation() {
  framesSinceLost++;

  float alpha = 166 * framesSinceLost / 80;
  if (alpha > 166) alpha = 166;
  fill(127, alpha);
  rectMode(CORNER);
  noStroke();
  rect(0, 0, 800, 500);

  float textAlpha = 255 * (framesSinceLost - 80) / 80;
  if (textAlpha > 255); 
  textAlpha = 255;
  fill(255, textAlpha);
  textSize(70);
  text("YOU LOST...", 265, 260);
}
/*
Encompasses: The Path for Balloons, Balloon Movement
 */

// ------- CODE FOR THE PATH
ArrayList<PVector> points = new ArrayList<PVector>(); // The points on the path, in order.
final float PATH_RADIUS = 20;
void addPointToPath(float x, float y) {
  points.add(new PVector(x, y));
}

void initPath() {
  addPointToPath(0, 200);
  addPointToPath(50, 200);
  addPointToPath(200, 150);
  addPointToPath(350, 200);
  addPointToPath(500, 150);
  addPointToPath(650, 200);
  addPointToPath(650, 300);
  addPointToPath(500, 250);
  addPointToPath(350, 300);
  addPointToPath(200, 250);
  addPointToPath(50, 300);
  addPointToPath(50, 400);
  addPointToPath(200, 350);
  addPointToPath(350, 400);
  addPointToPath(500, 350);
  addPointToPath(650, 400);
  addPointToPath(800, 350);
}

void drawPath() {
  stroke(#4C6710);
  strokeWeight(PATH_RADIUS * 2 + 1);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }

  stroke(#7b9d32);
  strokeWeight(PATH_RADIUS * 2);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }
}

HashMap<Float, PVector> dp = new HashMap<Float, PVector>();
// GIVEN TO PARTICIPANTS BY DEFAULT
PVector getLocation(float travelDistance)
{
  PVector memoized = dp.get(travelDistance);
  if (memoized != null) {
    return memoized;
  }
  float originalDist = travelDistance;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    float distance = dist(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    if (distance <= EPSILON || travelDistance >= distance) {
      travelDistance -= distance;
    } else {
      // In between two points
      float travelProgress = travelDistance / distance;
      float xDist = nextPoint.x - currentPoint.x;
      float yDist = nextPoint.y - currentPoint.y;
      float x = currentPoint.x + xDist * travelProgress;
      float y = currentPoint.y + yDist * travelProgress;
      dp.put(originalDist, new PVector(x, y));
      return new PVector(x, y);
    }
  }
  // At end of path
  dp.put(originalDist, points.get(points.size() - 1));
  return points.get(points.size() - 1);
}
// -------------- TEMPLATE CODE BEGINS ---------------- (Participants will NOT need to code anything below this line)

ArrayList<PVector> center = new ArrayList<PVector>(), velocity = new ArrayList<PVector>(); // Stores the location of each projectile and how fast it should move each frame
ArrayList<float[]> projectileData = new ArrayList<float[]>(); // Stores additional projectile data (unrelated to motion)
ArrayList<HashSet<Integer>> balloonsHit = new ArrayList<HashSet<Integer>>(); // Stores a list of balloons that each projectile has hit, so it doesn't hit the same balloon twice 
// For Participants: The HashSet data structure is like an ArrayList, but can tell you whether it contains a value or not very quickly
// The downside of HashSets is that there is no order or indexes, so you can't use it like a normal list
// Think of it like throwing items into an unorganized bin 

final int damage = 0, pierce = 1, angle = 2, currDistTravelled = 3, maxDistTravelled = 4, thickness = 5, dmgType = 6; // Constants to make accessing the projectileData array more convenient
final int projectileRadius = 11;

// Adds a new projectile
void createProjectile(PVector centre, PVector vel, float damage, int pierce, float maxDistTravelled, float thickness, int dmgType) {
  balloonsHit.add(new HashSet<Integer>()); // Adds an empty set to the balloonsHit structure - this represents the current projectile, not having hit any balloons yet.
  center.add(centre); // Adds the starting location of the projectile as the current location
  velocity.add(vel); // Adds the velocity of the projectile to the list
  float angle = atan2(vel.y, vel.x);
  projectileData.add(new float[]{damage, pierce, angle, 0, maxDistTravelled, thickness, dmgType});
}

// Checks the distance from a point to a projectile using the pointDistToLine() method coded earlier
float distToProjectile(int projectileID, PVector point) {
  float[] data = projectileData.get(projectileID);
  float width = cos(data[angle]), height = sin(data[angle]);
  PVector displacement = new PVector(width, height).mult(projectileRadius);
  PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
  return pointDistToLine(start, end, point);
}

// Checks if a projectile is ready to be removed (is it off screen? has it already reached its maximum pierce? has it exceeded the maximum distance it needs to travel?)
public boolean dead(int projectileID) {
  float[] data = projectileData.get(projectileID);
  return offScreen(projectileID) || data[pierce] == 0 || data[currDistTravelled] > data[maxDistTravelled];
}

// Checks if a projectile is off-screen 
public boolean offScreen(int projectileID) {
  return center.get(projectileID).x < 0 || center.get(projectileID).x > 800 || center.get(projectileID).y < 0 || center.get(projectileID).y > 500;
}

// Displays a projectile and handles movement & collision via their respective methods
void drawProjectile(int projectileID) {
  float[] data = projectileData.get(projectileID);
  stroke(255);
  strokeWeight(data[thickness]);
  float width = cos(data[angle]), height = sin(data[angle]);
  PVector displacement = new PVector(width, height).mult(projectileRadius);
  PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
  line(start.x, start.y, end.x, end.y);

  handleProjectileMovement(projectileID);
  handleCollision(projectileID);
}

// Updates projectile locations
void handleProjectileMovement(int projectileID) {
  PVector nextLocation = PVector.add(center.get(projectileID), velocity.get(projectileID)); // Adds the velocity to the current position
  center.set(projectileID, nextLocation); // Updates the current position

  float[] data = projectileData.get(projectileID);
  data[currDistTravelled] += velocity.get(projectileID).mag(); // Tracks the current distance travelled, so that if it exceeds the maximum projectile range, it disappears
}

// Checks collision with balloons
void handleCollision(int projectileID) {
  float[] data = projectileData.get(projectileID);
  for (float[] balloon : balloons) {
    if (balloon[delay] != 0) continue; // If the balloon hasn't entered yet, don't count it
    PVector position = getLocation(balloon[distanceTravelled]);
    if (distToProjectile(projectileID, position) <= balloonRadius / 2 + data[thickness] / 2) {
      if (data[pierce] == 0 || balloonsHit.get(projectileID).contains((int) balloon[ID])) continue; // Already hit the balloon / already used up its max pierce
      data[pierce]--; // Lowers the pierce by 1 after hitting the balloon
      balloonsHit.get(projectileID).add((int) balloon[ID]); // Adds the projectile to the set of already hit balloons
      if (data[dmgType] == 3) {
        // PVector test = pointDistToLine(data[], getLocation(balloon[distanceTravelled]));
        // float ang = atan2(distToProjectile(projectileID, getLocation(balloon[distanceTravelled])));
        PVector cen = center.get(projectileID);
        velocity.set(projectileID, distanceFrom(cen.x, cen.y, closestBalloon(cen, projectileID).x, closestBalloon(cen, projectileID).y));
        float ang = atan2(cen.x, cen.y);
        projectileData.set(projectileID, new float[]{data[damage], data[pierce], ang, data[currDistTravelled], data[maxDistTravelled], data[thickness], data[dmgType]});
      }
      hitBalloon(projectileID, balloon);
    }
  }
}
// -------------- TEMPLATE CODE ENDS ---------------- (Participants will NOT need to code anything abode this line)

// Gets the vector distance from one point to another
PVector distanceFrom (float x1, float y1, float x2, float y2) {
  return new PVector (x2-x1, y2-y1);
}

PVector closestBalloon (PVector loc, int projectileID) {
  PVector closeBalloon = new PVector();
  boolean found = false;
  float diff = Float.MAX_VALUE, prev = Float.MAX_VALUE;
  for (float[] balloon : balloons) {
    if (balloon[delay] == 0 && !balloonsHit.get(projectileID).contains((int) balloon[ID])) {
      found = true;
      diff = dist(loc.x, loc.y, getLocation(balloon[distanceTravelled]).x, getLocation(balloon[distanceTravelled]).y);
    }
    if (diff < prev) {
      closeBalloon = getLocation(balloon[distanceTravelled]);
    }
    prev = min(diff, prev);
  }
  if (found)
    return closeBalloon;
  else
    return new PVector(-1000, 200);
}

// Code that is called when a projectile hits a balloon
void hitBalloon(int projectileID, float[] balloonData) {
  float[] data = projectileData.get(projectileID);

  balloonData[hp] -= data[damage]; // Deals damage

  if (data[dmgType] == slow && balloonData[slowed] == 0) { // Slows down the balloon
    balloonData[type] *= 0.7;
    balloonData[slowed] = 1;
  }
}

// Tracks the tower that is closest to the end, within the vision of the tower
PVector track(PVector towerLocation, int vision) {
  float maxDist = 0;
  PVector location = null;
  for (float[] balloon : balloons) {
    PVector balloonLocation = getLocation(balloon[distanceTravelled]);
    // Checks if the tower can see the balloon
    if (dist(balloonLocation.x, balloonLocation.y, towerLocation.x, towerLocation.y) <= vision) {
      // If the balloon has travelled further than the previously stored one, it is now the new fastest
      if (balloon[distanceTravelled] > maxDist) {
        location = balloonLocation;
        maxDist = balloon[distanceTravelled];
      }
    }
  }
  return location;
}

// Handles all projectile creation
void handleProjectiles() {
  for (int i = 0; i < towers.size(); i++) {
    PVector location = towers.get(i);
    int[] data = towerData.get(i);
    data[cooldownRemaining]--;
    PVector balloon = track(location, data[towerVision]);

    // Cooldown is 0 and there is a balloon that the tower tracks shoots a projectile
    if (data[cooldownRemaining] <= 0 && balloon != null) {
      data[cooldownRemaining] = data[maxCooldown]; // Resets the cooldown

      PVector toMouse = new PVector(balloon.x - location.x, balloon.y - location.y);

      if (data[projectileType] == def) {
        final int speed = 24, damage = 5, pierce = 1, thickness = 2, maxTravelDist = 300;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());

        PVector velocity = PVector.mult(unitVector, speed);
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, def);
        // Default type
      } else if (data[projectileType] == eight) {
        // Spread in 8
        for (int j = 0; j < 8; j++) {
          final int speed = 18, damage = 4, pierce = 2, thickness = 2, maxTravelDist = 150;
          float angle = (PI * 2) * j / 8;
          PVector unitVector = PVector.div(toMouse, toMouse.mag());

          PVector velocity = PVector.mult(unitVector, speed).rotate(angle);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, eight);
        }
      } else if (data[projectileType] == slow) {
        //glue gunner - slows balloons
        final int speed = 15, damage = 1, pierce = 5, thickness = 6, maxTravelDist = 220; //slow-ish speed, low damage, high pierce, low range
        PVector unitVector = PVector.div(toMouse, toMouse.mag());

        PVector velocity = PVector.mult(unitVector, speed);
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, slow);
      } else if (data[projectileType] == lightning) {
        // chain lightning wizard monkey - lightning attack hits consecutive balloons
        final int speed = 40, damage = 5, pierce = 25, thickness = 4, maxTravelDist = 400;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        PVector velocity = PVector.mult(unitVector, speed);
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, lightning);
      }
    }
  }
  // Displays projectiles and removes those which need to be removed
  for (int projectileID = 0; projectileID < projectileData.size(); projectileID++) {
    drawProjectile(projectileID);
    if (dead(projectileID)) {
      projectileData.remove(projectileID);
      center.remove(projectileID);
      velocity.remove(projectileID);
      balloonsHit.remove(projectileID);
      projectileID--;
    }
  }
}
