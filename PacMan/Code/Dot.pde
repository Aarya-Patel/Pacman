/** 
 * Dot.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the Dot class that extends the Consumable class
 * It is a consumable that spwans every tile 
 */

public class Dot extends Consumable{
  /** 
   * Creates a Dot object 
   * @param int x - the x coordiante of the dot
   * @param int y - the y coordinate of the dot
   */
  public Dot(int x, int y){
    super(10, x, y);
  }
 
   /**
   * Shows the dot
   * @return void
   */
  public void show(){
    if(!this.isEaten()){
      fill(255,255,0);
      stroke(255,255,0);
      ellipse(this.getX(), this.getY(),3 ,3);
    }
  }
}
