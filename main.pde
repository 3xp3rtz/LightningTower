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

// main loop
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

  rectMode(CORNER);
  if (autoStart)
    fill(#2bd823);
  else
    fill(#6fd66a);
  rect(autoStartWave[0], autoStartWave[1], autoStartWave[2]-autoStartWave[0], autoStartWave[3]-autoStartWave[1]);
  beginShape();
  vertex(autoStartWave[0]+40, autoStartWave[1]+15);
  vertex(autoStartWave[0]+40, autoStartWave[3]-15);
  vertex(autoStartWave[0]+60, (autoStartWave[1]+autoStartWave[3])/2);
  endShape(CLOSE);
  beginShape();
  vertex(autoStartWave[0]+20, autoStartWave[1]+15);
  vertex(autoStartWave[0]+20, autoStartWave[3]-15);
  vertex(autoStartWave[0]+40, (autoStartWave[1]+autoStartWave[3])/2);
  endShape(CLOSE);

  if (balloons.size() == 0) {
    if (!waveEnd) {
      increaseBalance(150+(wave/5*50));
      waveEnd = true;
    }
    fill(#40CB68);
    if (clickNext || autoStart) {
      clickNext = false;
      createWave(wave);
    }
  } else
    fill(#77d391);
  rect(startWave[0], startWave[1], startWave[2]-startWave[0], startWave[3]-startWave[1]);
  beginShape();
  vertex(startWave[0]+30, startWave[1]+15);
  vertex(startWave[0]+30, startWave[3]-15);
  vertex(startWave[0]+50, (startWave[1]+startWave[3])/2);
  endShape(CLOSE);
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

// Whenever the user releases their mouse
void mouseReleased() {
  if (currentlyDragging != notDragging) {
    handleDrop(currentlyDragging);
  }
  currentlyDragging = notDragging;
  if (hoverNextWave(mouseX, mouseY)) {
    clickNext = true;
  }
  if (hoverAutoStart(mouseX, mouseY)) {
    if (autoStart) {
      autoStart = false;
    } else {
      autoStart = true;
    }
  }
}
