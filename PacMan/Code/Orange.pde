/** 
 * Orange.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the Orange class that extends the Consumable class
 * It is a consumable that randomly spawns
 */
 
public class Orange extends Consumable{
  //The Orange img that is used when it spawns
  PImage orange = loadImage("Orange.PNG"); 
  
  /** 
   * Creates an Orange object 
   * @param int x - the x coordiante of the orange
   * @param int y - the y coordinate of the orange
   */
  public Orange(int x, int y){
    super(300, x, y, true);
  }
 
   /**
   * Shows the orange
   * @return void
   */
  public void show(){
    if(!this.isEaten()){
      image(orange, this.getX()-8, this.getY()-8);
    }
  }
}
