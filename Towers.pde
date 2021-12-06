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
  300, 
  450, //eight-shot tower
  325, //slow tower
  1250 // lightning tower
};

int[] makeTowerData(int towerID) {  
  if (towerID == def) {
    return new int[] {
      10, // Cooldown between next projectile
      10, // Max cooldown
      towerVisions[def], // Tower Vision
      def // Projectile ID
    };
  } else if (towerID == eight) {
    return new int[] {
      20, 
      20, 
      towerVisions[eight], 
      eight
    };
  } else if (towerID == slow) {
    return new int[] {
      15, 
      30, 
      towerVisions[slow], 
      slow
    };
  } else if (towerID == lightning) {
    return new int[] {
      15, 
      20, 
      towerVisions[lightning], 
      lightning
    };
  }
  return new int[] {}; //filler since we need to return something
}
