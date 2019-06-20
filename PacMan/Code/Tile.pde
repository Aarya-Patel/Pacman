/** 
 * Tile.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * The tile class holds all the consumables
 */

public class Tile {

  //Each tile can be any one of these below
  boolean wall = false;
  Dot dot = null;
  Cherry cherry = null;
  Berry berry = null;
  Orange orange = null;
  BigDot bigDot = null;
  Teleport tele = null;

  //Pos will be the center of each tile
  PVector pos;

  /** 
   * Creates an Tile object 
   * @param int x - the x coordiante of the teleport
   * @param int y - the y coordinate of the teleport
   * @param int n - n decides the type of consumable it is
   */

  public Tile(int x, int y, int n) {
    //Position of tile
    pos = new PVector(x*16+8, y*16+8);

    //Depending on the case of n, assign the consumable to the object
    switch(n) {
      //0 is a dot
    case 0: 
      dot = new Dot(x, y);
      break;
      //1 is a wall
    case 1: 
      wall = true;
      break;
      //2 is a bigDot
    case 2: 
      bigDot = new BigDot(x, y);
      break;
      //3 is a fruit
    case 3: 
      cherry = new Cherry(x, y);
      berry = new Berry(x, y);
      orange = new Orange(x, y);
      break;
      //6 is a teleport
    case 6: 
      tele = new Teleport(x, y);
      break;
      //Otherwise break
    default:
      break;
    }
  }
  
  /**
   * Shows the tile depending on what the tile holds
   * @return void
   */
  public void show() {
    //Check for the consumable and show it
    if (dot != null) {
      dot.show();
    } else if (bigDot != null) {
      bigDot.show();
    } else if (tele != null) {
      tele.show();
    } else if (cherry != null && !cherry.isEaten()) {
      cherry.show();
    } else if (berry != null && !berry.isEaten()) {
      berry.show();
    } else if (orange != null && !orange.isEaten()) {
      orange.show();
    }
  }
}
