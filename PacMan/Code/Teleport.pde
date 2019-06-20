/** 
 * Teleport.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the Teleport class that extends the Consumable class
 * It is a consumable that spwans on the end of the tube used for teleporting
 */

public class Teleport extends Consumable {
  /** 
   * Creates an Teleport object 
   * @param int x - the x coordiante of the teleport
   * @param int y - the y coordinate of the teleport
   */
  public Teleport(int x, int y) {
    super(0, x, y);
  }
  
  /**
   * Shows the teleport
   * @return void
   */
  public void show() {
    fill(0, 255, 0);
    stroke(0, 255, 0);
    ellipse(this.getX(), this.getY(), 12, 12);
  }
}
