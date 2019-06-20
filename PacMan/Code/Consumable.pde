/** 
 * Consumable.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This class defines all the objects that can be eaten by Pacman
 */

public class Consumable {

  //Position vector
  private PVector pos;
  //Each object will have specific points
  private int point;
  //Eaten var that will decide if it must be shown or not
  private boolean eaten = false;


  /** 
   * Creates a Consumable object 
   * @param int x - the x coordiante of the consumable
   * @param int y - the y coordinate of the consumable
   */
  public Consumable(int point, int x, int y) {
    this.point = point;
    //Set the pos vector to the corresponding grid location on the screen
    pos = new PVector(x*16+8, y*16+8);
  }

  /** 
   * Creates a Consumable object 
   * For the fruits since they will start off eaten at firstto avoid displaying them
   * @param int x - the x coordiante of the consumable
   * @param int y - the y coordinate of the consumable
   * @param boolean eaten - used to indicate if its eaten already
   */
  public Consumable(int point, int x, int y, boolean eaten) {
    this.point = point;
    //Set the pos vector to the corresponding grid location on the screen
    pos = new PVector(x*16+8, y*16+8);
    this.eaten = eaten;
  }

  /**
   * Sets the consumable to eaten = true and increments the score var with this.points
   * @return void
   */
  public void ate() {
    this.eaten = true;
    score += this.point;
  }

  /**
   * Sets the eaten var to the input
   * @param boolean bool - the desired value for the eaten var
   * @return void
   */
  public void setEaten(boolean bool) {
    this.eaten = bool;
  }

  /**
   * Returns eaten var
   * @return boolean eaten
   */
  public boolean isEaten() {
    return eaten;
  }

  /**
   * Returns the x co-ordinate of an object
   * @return int x
   */
  public int getX() {
    return (int)pos.x;
  }

  /**
   * Returns the y co-ordinate of an object
   * @return int y
   */
  public int getY() {
    return (int)pos.y;
  }
}
