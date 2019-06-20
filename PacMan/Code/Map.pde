/** 
 * Map.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * The map class contains the fundamental mechanism for movement and spawning 
 */

public class Map {
  //This variable will rotate between cherry -> berry -> ornage -> cherry ...
  private int curFruit = 0;
  //This will track whether or not all the dots have been consumed
  private boolean respawnDot = true;


  //The map layout with numbers refferring to the actual tiles
  //0 - path contains dot
  //1 - wall
  //2 - bigdot + is a path
  //3 - area where consumables pop up
  //4 - door to trap ghost
  private int[][] tilesRepresentation = { 
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
    {1, 2, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2, 1}, 
    {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 1, 1, 4, 4, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 5, 5, 5, 5, 5, 5, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {6, 0, 0, 0, 0, 0, 0, 3, 3, 3, 1, 5, 5, 5, 5, 5, 5, 1, 3, 3, 3, 0, 0, 0, 0, 0, 0, 6}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 5, 5, 5, 5, 5, 5, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 1, 1, 1, 1, 1, 0, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
    {1, 2, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2, 1}, 
    {1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1}, 
    {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1}, 
    {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1}, 
    {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1}, 
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}};

  //Actual map
  private Tile[][] tile = new Tile[31][28];

  /** 
   * Creates an Map object that creates Tiles corresponding to its matrixNum
   */
  public Map() {
    //Loop through the array and assign the correct tiles to the map
    for (int i = 0; i < 31; i++) {
      for (int j = 0; j < 28; j++) {
        //0 is a regular tile w/ a dot
        if (tilesRepresentation[i][j] == 0) {
          tile[i][j] = new Tile(j, i, 0);
        } 
        //1 is a wall
        else if (tilesRepresentation[i][j] == 1) {
          tile[i][j] = new Tile(j, i, 1);
        } 
        //2 is a BigDot
        else if (tilesRepresentation[i][j] == 2) {
          tile[i][j] = new Tile(j, i, 2);
        } 
        //3 is a possible spawning area for fruits
        else if (tilesRepresentation[i][j] == 3) {
          tile[i][j] = new Tile(j, i, 3);
        } 
        //4 is the door to the jail
        else if (tilesRepresentation[i][j] == 4) {
          tile[i][j] = new Tile(j, i, 4);
        } 
        //5 is the jail
        else if (tilesRepresentation[i][j] == 5) {
          tile[i][j] = new Tile(j, i, 5);
        } 
        //6 is a teleport
        else if (tilesRepresentation[i][j] == 6) {
          tile[i][j] = new Tile(j, i, 6);
        }
      }
    }
  }

  /**
   * Shows the map with all the consumables
   * It also checks to see it must respawn all the Dots and BigDots
   * @return void
   */
  public void show() {
    //This will determine if a respawn is needed
    this.respawnDot = true;

    //Loop through the tiles[][]
    for (int i = 0; i < 31; i++) {
      for (int j = 0; j < 28; j++) {
        //Get the tile and show it
        Tile temp = getTile(j, i);
        temp.show();

        //If the tile is a dot and it has not been eaten, then reset is not needed
        if (temp.dot != null && !temp.dot.isEaten()) {
          this.respawnDot = false;
        } 
        //If the tile is a bigDot and has not been eaten, then the reset is not needed
        else if (temp.bigDot != null && !temp.bigDot.isEaten()) {
          this.respawnDot = false;
        }
      }
    }

    //At the end of the loop, reset the field
    if (this.respawnDot == true) {
      this.resetField();
    }
  }

  /**
   * Resets the field and all the dots and bigDots on the map
   * @return void
   */
  public void resetField() {
    for (int i = 0; i < 31; i++) {
      for (int j = 0; j < 28; j++) {
        Tile temp = getTile(j, i);

        if (temp.dot != null) {
          temp.dot.setEaten(false);
        } else if (temp.bigDot != null) {
          temp.bigDot.setEaten(false);
        }
      }
    }
  }


  public Tile getTile(int x, int y) {
    if (x >= 0 && x <= 27 && y >=0 && y <= 31) {
      return tile[y][x];
    }
    return null;
  }

  public void spawnCon() {
    int[] x = {12, 12, 15, 15, 7, 8, 19, 20, 9, 9, 18, 18, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 9, 9, 9, 9, 9, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 18, 18, 18, 18, 18};
    int[] y = {9, 10, 9, 10, 14, 14, 14, 14, 18, 19, 18, 19, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 14, 13, 12, 15, 16};

    int n = (int)(random(x.length*10));
    //System.out.println(n +" " +x.length);
    int rand = (int)(random(500));
    //System.out.println(n +" " +rand);
    if (rand < 10 && n < x.length) {
      Tile temp = getTile(x[n], y[n]);

      if (curFruit == 0 && temp.cherry != null) {
        temp.cherry.setEaten(false);
        this.curFruit = 1;
      } else if (curFruit == 1 && temp.berry != null) {
        temp.berry.setEaten(false);
        this.curFruit = 2;
      } else if (curFruit == 2 && temp.orange != null) {
        temp.orange.setEaten(false);
        this.curFruit = 0;
      }
    }
  }



  public int getTileNum(int x, int y) {
    if (x >= 0 && x <= 27 && y >=0 && y <= 31) {
      return tilesRepresentation[y][x];
    }
    return -1;
  }
}
