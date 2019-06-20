/** 
 * Cherry.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the Cherry class that extends the Consumable class
 * It is a consumable that randomly spawns
 */
public class Cherry extends Consumable {
  //The Cherry img that is used when it spawns
  PImage cherry = loadImage("Cherry.PNG"); 

  /** 
   * Creates a Cherry object 
   * @param int x - the x coordiante of the cherry
   * @param int y - the y coordinate of the cherry
   */
  public Cherry(int x, int y) {
    super(100, x, y, true);
  }

  /**
   * Shows the cherry
   * @return void
   */
  public void show() {
    if (!this.isEaten()) {
      image(cherry, this.getX()-8, this.getY()-8);
    }
  }
}
