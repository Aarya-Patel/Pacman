/** 
 * Berry.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the Berry class that extends the Consumable class
 * It is a consumable that randomly spawns
 */

public class Berry extends Consumable {
  //The berry img that is used when it spawns
  PImage berry = loadImage("Berry.PNG"); 

  /** 
   * Creates a Berry object 
   * @param int x - the x coordiante of the berry
   * @param int y - the y coordinate of the berry
   */
  public Berry(int x, int y) {
    super(200, x, y, true);
  }

  /**
   * Shows the berry
   * @return void
   */
  public void show() {
    //Makes sure it isn't eaten then show it
    if (!this.isEaten()) {
      image(berry, this.getX()-7, this.getY()-8);
    }
  }
}
