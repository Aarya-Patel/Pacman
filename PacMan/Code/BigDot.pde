/** 
 * BigDot.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the BigDot class that extends the Consumable class
 * It is a consumable that makes the Ghosts go into frenzy mode
 */

public class BigDot extends Consumable {

  /**
   * Creates a BigDot
   * @param int x - the x coordinate of the BigDot
   * @param int y - the y coordinate of the BigDot
   */
  public BigDot(int x, int y) {
    super(50, x, y);
  }

  /**
   * Shows the BigDot
   * @return void
   */
  public void show() {
    //Makes sure it isn't eaten
    if (!this.isEaten()) {
      fill(255, 255, 0);
      stroke(255, 255, 0);
      ellipse(this.getX(), this.getY(), 8, 8);
    }
  }
}
