/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
*/

// Displays and moves balloons
void updatePositions(float[] balloon) {
  // Only when balloonProps[1] is 0 (the delay) will the balloons start moving.
  if (balloon[delay] == 0) {

    PVector position = getLocation(balloon[distanceTravelled]);
    float travelSpeed = balloon[speed];
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

    fill(balloonColors[(int)(balloon[type])-1]);
    if (balloon[slowed] == 1) {
      fill(slowedBalloonColors[(int)(balloon[type])-1]);
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
      handleBalloonPop((int)balloon[type]);
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
