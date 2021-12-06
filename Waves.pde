/* ------------ALL-BALLOONS----------- */

// existing balloons
ArrayList<float[]> balloons = new ArrayList<float[]>();

// {Number of "steps" taken, frames of delay before first step, speed, hp, slowed (0=no, 1=yes)}
final int distanceTravelled = 0, delay = 1, type = 2, speed = 3, hp = 4, slowed = 5, ID = 6;

final int balloonRadius = 25; //Radius of the balloon

/* ----------BALLOON-VALUES----------- */

/* ----SETTING-TYPE-VALUES-FOR-EACH-BALLOON---- */

// regular
final int redBalloon = 1, blueBalloon = 2, greenBalloon = 3, yellowBalloon = 4, pinkBalloon = 5, purpleBalloon = 6;
int totalBalloonColors = 7;

// lead
final int leadBalloon = 7;


/* <--------------WIP-------------> */

/*
// camo
final int camoRedBalloon = 12, camoBlueBalloon = 13, camoGreenBalloon = 14, camoYellowBalloon = 15, camoPinkBalloon = 16, camoPurpleBalloon = 17;
final int camoLeadRedBalloon = 18, camoLeadBlueBalloon = 19, camoLeadGreenBalloon = 20, camoLeadYellowBalloon = 21, camoLeadPinkBalloon = 22;
*/

/* <--------------WIP-------------> */


int wave = 1, balloonType;

// maximum balloon health
final int[] maxBalloonHP = {0, 10, 20, 40, 60, 80, 100, 150};


/* ----------BALLOON-COLORS----------- */

// regular balloon colors
final color[] balloonColors = {#000000, #ff3d36, #368fff, #07f230, #ffeb31, #ff55e3, #9739ea, #a0a0a0};
// slowed balloon colors
final color[] slowedBalloonColors = {#000000, #ff8080, #98c7ff, #a7f0b3, #fff598, #ffaaf1, #b678ed, #d4d4d4};


/* -----------WAVE-CREATION----------- */

// making each wave
void createWave(int waveNum) {
  
  waveEnd = false;
  
  // spacing between balloons
  int spacing;

  
  // wave 1
  // 10 30-spaced red balloons
  
  if (waveNum == 1) {
    for (int i = 0; i < 10; i++) {
      balloonType = redBalloon;
      spacing = 30;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
    

  // wave 2
  // 25 10-grouped red balloons

  } else if (waveNum == 2) {
    for (int i = 0; i < 25; i++) {
      balloonType = redBalloon;
      spacing = 10;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 3
  // 15 20-spaced blue balloons
  
  } else if (waveNum == 3) {
    for (int i = 0; i < 15; i++) {
      balloonType = blueBalloon;
      spacing = 20;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 4
  // 20 15-grouped blue balloons, 30 10-grouped red balloons
  
  } else if (waveNum == 4) {
    for (int i = 0; i < 35; i++) {
      balloonType = blueBalloon;
      spacing = 10;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  
  
  /* WAVE 5 - 7 RANDOMLY GENERATED */
  

  
  // wave 8
  // 35 15-spaced green balloons
  
  } else if (waveNum == 8) {
    for (int i = 0; i < 35; i++) {
      balloonType = greenBalloon;
      spacing = 15;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }

  // wave 9
  // 15 20-spaced yellow balloons
  
  } else if (waveNum == 9) {
    for (int i = 0; i < 15; i++) {
      balloonType = yellowBalloon;
      spacing = 20;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
    
  // wave 10
  // 35 5-grouped green balloons, 20 15-spaced yellow balloons
  
  } else if (waveNum == 10) {
    for (int i = 0; i < 65; i++) {
      balloonType = greenBalloon;
      spacing = 5;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
    for (int i = 0; i < 20; i++) {
      balloonType = yellowBalloon;
      spacing = 10;
      balloons.add(new float[]{0, i * spacing + 155, balloonType + 1, balloonType + 1, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 12
  // first purple balloons
  // 20 15-spaced purple balloons
  
  } else if (waveNum == 12) {
    for (int i = 0; i < 20; i++) {
      balloonType = purpleBalloon;
      spacing = 15;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, 3, maxBalloonHP[balloonType], 0, i});
    }
  
  // wave 15
  // first lead balloons
  // 10 20-spaced lead balloons
  
  } else if (waveNum == 15) {
    for (int i = 0; i < 10; i++) {
      balloonType = leadBalloon;
      spacing = 20;
      balloons.add(new float[]{0, i * spacing + 20, balloonType + 1, 3, maxBalloonHP[balloonType], 0, i});
    }
  
  // if wave is unspecified
  // randomly generate a wave
  
  } else {
    int rand, rand2, rand3;
    for (int i = 0; i < ((wave + 1)/3); i++) {
      rand = (int)random(max(1, wave/3-1), min(totalBalloonColors, wave/3)); // random balloon type (color)
      balloonType = rand;

      rand2 = (int)random(2, 6); // number of balloons

      rand3 = (int)random(1, 5); // spacing between balloons
      
      spacing = rand3*5;

      for (int j = 0; j < rand2 * 5; j++) {
        balloons.add(new float[]{0, (i * rand2 * rand3 * 14) + j * spacing + 20, balloonType + 1, (balloonType+5)%6+2, maxBalloonHP[balloonType], 0, (rand2 * i) + j});
      }
    }
  }
  
  
  println("WAVE " + wave);
  wave += 1;
}
