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


final int towerSize = 40;
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

// Tracks the balloon that is closest to the end, within the vision of the tower
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
