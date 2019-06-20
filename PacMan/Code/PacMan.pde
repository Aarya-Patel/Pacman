/** 
 * Pacman.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * The pacman class is responsible for user movement and eating consumables
 */

public class PacMan implements GameMechanics {
  //Position vector
  private PVector pos = null;
  private PVector matrixPos;

  //Direction of travel 
  private int[] dir = new int[4];

  //Timer for the tick method
  private int timer = 0;

  //Num of lives
  private int lives = 3;

  //FrenzyTimer for how long the ghost will stay in that mode
  private int frenzyTimer = 0;



  /** 
   * Creates an Pacman object, starting position is always the same
   */
  public PacMan() {
    pos = new PVector(13*16 + 8, 23 * 16 + 8);
  }

  /**
   * Shows the pacman
   * @return void
   */
  public void show() {
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse(pos.x, pos.y, 16, 16);
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

  /**
   * Decrements a variable for an effective in game simultaneous delay
   * @return void
   */
  public void tick() {
    //Decrement the orignal timer
    if (this.timer > 0) {
      this.timer -= 1;
    } 
    //If the frenzyTimer is greater than 0, decrement that 
    if (frenzyTimer > 0) {
      frenzyTimer -= 1;
      //If the timer hits 0 then set the ghost back to normal
      if (frenzyTimer == 0) {
        blinky.setNormal();
        pinky.setNormal();
        inky.setNormal();
        clyde.setNormal();
      }
    }
  }

  /**
   * Returns the number of lives of pacman
   * @return int - num of lives
   */
  public int getLives() {
    return this.lives;
  }


  /**
   * Death of pacman, randomly spawn pacman on the map
   * @return void
   */
  public void die() {
    //Decrement the lives and reset the position to the original
    if (this.lives > 0) {

      this.lives -= 1;

      //Generate random nums (nums range within the size of the map 2D array)
      int xCor = (int)random(28);
      int yCor = (int)random(31);

      //Make sure that pacman doesn't spawn on an invalid position
      while (!isValid(xCor, yCor)) {
        xCor = (int)random(20);
        yCor = (int)random(20);
      }

      //Set the pos vector to the coordinate of the new spawn location
      pos = new PVector(xCor *16 + 8, yCor * 16 + 8);      

      //Reset the direction to avoid moving right off of spawn
      dir = new int[4];
    }
  }

  /**
   * Checks if pacman is alive
   * @return boolean - true if alive, false if dead
   */
  public boolean isAlive() {
    if (this.lives > 0) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * Teleports the player or AI 
   * @return void
   */
  public void teleport() {
    int corX = (this.getX()-8)/16; 
    if (corX == 0) {
      pos.x = 26*16+8;
    } else {
      pos.x = 24;
    }
  }

  /**
   * Moving pacman based off of user input
   */
  public void playerMovement() {
    //Initialze the matrixPos
    matrixPos = new PVector((pos.x-8)/16, (pos.y-8)/16);

    //Check if a key is pressed
    if (keyPressed) {
      //Check if the key pressed was up and if the tile above is vaild
      if (keyCode == UP && this.isValid((int)matrixPos.x, (int)(matrixPos.y - 1))) {
        //Set the direction to up
        dir = new int[4];
        dir[0] = 1;
      } 
      //Check if the key pressed was down and if the tile below is vaild
      else if (keyCode == DOWN && this.isValid((int)matrixPos.x, (int)(matrixPos.y + 1))) {
        //Set the direction to down
        dir = new int[4];
        dir[1] = 1;
      } 
      //Check if the key pressed was left and if the tile to the left is vaild
      else if (keyCode == LEFT && this.isValid((int)matrixPos.x-1, (int)(matrixPos.y))) {
        //Set the direction to the left
        dir = new int[4];
        dir[2] = 1;
      } 
      //Check if the key pressed was right and if the tile to the right is vaild
      else if (keyCode == RIGHT && this.isValid((int)matrixPos.x+1, (int)(matrixPos.y))) {
        //Set the direction to the right
        dir = new int[4];
        dir[3] = 1;
      }
    }

    //Can only move once the timer is 0
    if (timer == 0) {
      //Loop through the array and move in that direction
      for (int i = 0; i < dir.length; i++) {
        //Up
        if (dir[i] == 1) {
          if (i == 0 && this.isValid((int)matrixPos.x, (int)(matrixPos.y - 1))) {  
            pos.y  -= 16;
            matrixPos.y -= 1;
          } 
          //Down
          else if (i == 1 && this.isValid((int)matrixPos.x, (int)(matrixPos.y + 1))) {  
            pos.y  += 16;
            matrixPos.y += 1;
          } 
          //left
          else if (i == 2 && this.isValid((int)matrixPos.x-1, (int)(matrixPos.y))) {  
            pos.x  -= 16;
            matrixPos.x -= 1;
          }
          //Right
          else if (i == 3 && this.isValid((int)matrixPos.x+1, (int)(matrixPos.y))) {  
            pos.x  += 16;
            matrixPos.x += 1;
          }
        }
      }

      //Reset the timer and perform tile action
      timer = 5;

      //If the tile is 6 then teleport
      if (map.getTileNum((int)matrixPos.x, (int)matrixPos.y) == 6) {
        this.teleport();
      }

      //Perform the action at the new tile
      tileAction((int)(this.getX()-8)/16, (int)(this.getY()-8)/16);
    }
  }

  /**
   * Determines whether or not a position is valid using the map 2D array
   * @param int x - x coordinate of a tile
   * @param int y - y cooridnate of a tile
   * @return boolean - true if valid, false if not valid
   */
  public boolean isValid(int x, int y) {
    //Get the tile
    int temp = map.getTileNum(x, y);

    //The tile cannot be a wall or a jail door or a jail cell
    if (temp != 1 && temp != 4 && temp != -1 && temp != 5) {
      return true;
    } 

    return false;
  }

  /**
   * Performs an action at the specified tile
   * @param int x - x coordinate of a tile
   * @param int y - y cooridnate of a tile
   * @return void
   */
  public void tileAction(int x, int y) {
    //Get the tile
    Tile temp = map.getTile(x, y);
    //At first the consumable at that tile is null
    Consumable tileCons = null;
    
    //As long as we have a valid tile
    if (temp != null) {
      //Check to see the consumable at that tile
      //Check for a dot
      if (temp.dot != null) {
        tileCons = temp.dot;
      } 
      //Check for a bigDot
      else if (temp.bigDot != null) {
        tileCons = temp.bigDot;
      } 
      //Check for a cherry
      else if (!temp.cherry.isEaten()) {
        tileCons = temp.cherry;
      } 
      //Check for a berry
      else if (!temp.berry.isEaten()) {
        tileCons = temp.berry;
      } 
      //Otherwise its an orange
      else {
        tileCons = temp.orange;
      }

      //If the dot isn't eaten then eat it
      if (temp.dot != null && tileCons.isEaten() != true) {
        //Eat it
        temp.dot.ate();
        
        //Play the chomp music
        if (!chomp.isPlaying()) {
          chomp.amp(0.4);
          chomp.jump(0.2);
        }
      } 
      //If the bigDot isn't eaten then eat it
      else if (temp.bigDot != null && tileCons.isEaten() != true) {
        //Eat it
        temp.bigDot.ate(); 
        
        //Once the bigDot is eaten then play the frenzyMusic
        if (!frenzyMusic.isPlaying()) {
          startMusic.stop();
          frenzyMusic.amp(0.3);
          frenzyMusic.play();
        }
        
        //Set all the ghost into frenzyMode
        blinky.frenzyMode();
        pinky.frenzyMode();
        inky.frenzyMode();
        clyde.frenzyMode();
        
        //Set the timer to 550
        frenzyTimer = 550;
        
      } 
      //Otherwise it must be a fruit
      else if (tileCons.isEaten() != true) {
        //Eat the fruit
        tileCons.ate();
        //Play the sound effect
        eatFruit.play();
      }
    }
  }
}
