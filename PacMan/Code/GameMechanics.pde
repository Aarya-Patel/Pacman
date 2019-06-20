/** 
 * GameMechanics.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This interface defines basic methods that players and AI will need
 */

public interface GameMechanics {
  /**
   * Returns the x co-ordinate of an object
   * @return int x
   */
  public int getX();

  /**
   * Returns the y co-ordinate of an object
   * @return int y
   */
  public int getY();

  /**
   * Shows the objects on the screen
   * @return void
   */
  public void show();

  /**
   * Decrements a variable for an effective in game simultaneous delay
   * @return void
   */
  public void tick();
  
   /**
   * Determines whether or not a position is valid using the map 2D array
   * @param int x - x coordinate of a tile
   * @param int y - y cooridnate of a tile
   * @return boolean - true if valid, false if not valid
   */
  public boolean isValid(int x, int y);
  
   /**
   * Teleports the player or AI 
   * @return void
   */
  public void teleport();
}
