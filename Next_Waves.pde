/* ------------NEXT-WAVES------------- */

boolean clickNext = false;
boolean autoStart = false;
boolean hoverNextWave(int x, int y) {
  return (x >= startWave[0] && x <= startWave[2] && y >= startWave[1] && y <= startWave[3]);
}
boolean hoverAutoStart(int x, int y) {
  return (x >= autoStartWave[0] && x <= autoStartWave[2] && y >= autoStartWave[1] && y <= autoStartWave[3]);
}

int[] startWave = {20, 425, 100, 485}, autoStartWave = {120, 425, 200, 485};
