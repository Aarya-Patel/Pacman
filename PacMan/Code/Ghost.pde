/** 
 * Ghosts.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * The ghost class implments GameMechanics and is essentially an AI that chases pacman
 */

public class Ghost implements GameMechanics {
  //Position vector and jail position vector
  private PVector pos = new PVector();
  private PVector jailPos;

  //int r, g, b for display original color
  private int r;
  private int g;
  private int b;

  //Timer needed for the tick method
  private int timer = 10;

  //Direction of travel, used in move method
  private int[] dir = new int[4];

  //Eaten var needed when in frenzyMode
  private boolean eaten = false;

  //JailTime for staying jail
  private int jailTime;

  //Countdown timer once in jail
  private int jailCountDown = 0;

  //Booleans to check mode and positions
  private boolean frenzy = false;
  private boolean atDoor = false;

  //Color timer is used to swtich between blue and white, when in frenzy
  private int colorTimer = 0;

  /** 
   * Creates an Ghost object 
   * @param int x - the x coordiante of the orange
   * @param int y - the y coordinate of the orange
   * @param int jailTime - how long a ghost will stay in jail
   * @param int r - red value
   * @param int g - green value
   * @param int b - blue value
   */
  public Ghost(int x, int y, int jailTime, int r, int g, int b) {
    //The initial position vector is always the jailPosition vector
    pos = new PVector(y * 16 + 8, x * 16 + 8);
    jailPos = new PVector(y * 16 + 8, x * 16 + 8);
    this.r = r;
    this.g = g;
    this.b = b;
    this.jailTime = jailTime;
    this.timer = jailTime;
  }

  /**
   * Shows the Ghost depending on which mode it is in
   * @return void
   */
  public void show() {
    //If it isn't in frenzy then display a normal Ghost
    if (!this.frenzy) {
      //Make a circle with the r,g,b values specified in the constructor
      fill(r, g, b);
      stroke(r, g, b);
      ellipse(this.getX(), this.getY(), 16, 16);
    } else { // Otherwise it is in frenzyMode
      //Depending on the value of the timer it will remain white
      if (colorTimer > 15) {
        fill(255, 255, 255);
        stroke(255, 255, 255);
        ellipse(this.getX(), this.getY(), 16, 16);
      } else {
        //Then switch to blue
        fill(0, 0, 255);
        stroke(0, 0, 255);
        ellipse(this.getX(), this.getY(), 16, 16);
      }
    }
  }

  /**
   * Decrements a variable for an effective in game simultaneous delay
   * @return void
   */
  public void tick() {
    //Always decrement the original timer
    if (timer > 0) {
      this.timer -= 1;
    }
    //If it is jail because it was eaten then decrement the jailCounDown as well
    if (this.isInJail() && this.frenzy == true & jailCountDown > 0) {
      jailCountDown -= 1;
      //Once the count down hits 0 it can leave the jail
      if (jailCountDown == 0) {
        this.frenzy = false;
        this.eaten = false;
        this.atDoor = false;
      }
    }

    //Decrements the colorTimer when the Ghost is in frenzyMode
    if (colorTimer > 0) {
      colorTimer -= 1;
    } else if (colorTimer == 0 && this.frenzy == true) {
      colorTimer = 30;
    }
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
   * Moves the ghost towards the specified destination coordinate
   * @param int endX - the x coordinate of the destination
   * @param int endY - the y coordinate of the destination
   * @return void
   */
  public void move(int endX, int endY) {
    //Get the matrix position of the ghost
    int corX = (this.getX()-8)/16; 
    int corY = (this.getY()-8)/16; 

    //Movement is affected depending on the state of the ghost
    //If it in jail and the count down is 0 then move out of the jail to the specified position
    if ((this.isInJail() && jailCountDown == 0)) {
      moveTowards(14*16+8, 11*16+8);
    } 
    //Once the ghost is at the door of the jail while in frenzyMode it must proceed towards the jailPos vector
    else if (atDoor && this.frenzy == true) {
      moveTowards((int)jailPos.x, (int)jailPos.y);
    } 
    //If the ghost is eaten in frenzyMode and is not in jail, then move towards the door of the jail
    else if (this.eaten && !this.isInJail() && this.frenzy == true) { 
      //Towards the door of the jail
      moveTowards(13*16+8, 13*16+8);
      //Determines if the ghost is at the door
      if (this.eaten && pos.x == 13*16+8 && pos.y == 13*16+8) {
        atDoor = true;
      }
    } 
    //If the ghost is at the teleport, then call the teleport method
    else if (map.getTileNum(corX, corY) == 6) {
      this.teleport();
    } 
    //Otherwise everything is normal and move towards endX and endY
    else {
      //System.out.println(1);
      moveTowards(endX, endY);
    }
  }

  /**
   * Set the ghost into frenzyMode and set the colorTimer to 30
   * @return void
   */
  public void frenzyMode() {
    this.frenzy = true;
    colorTimer = 30;
  }

  /**
   * Set the ghost back to the normal states
   * @return void
   */
  public void setNormal() {
    //Remove them from frenzyMode
    this.frenzy = false;
    //Set the jailCountDown to 0, so they can start moving out 
    this.jailCountDown = 0;
    //Reset the eaten var to false
    this.eaten = false;
  }

  /**
   * Teleports the ghost 
   * @return void
   */
  public void teleport() {
    //Get the x coordinate of the ghost
    int corX = (this.getX()-8)/16; 

    //Check to see which portal it used and teleport to the other one
    if (corX == 0) {
      pos.x = 26*16+8;
    } else {
      pos.x = 24;
    }
  }

  /**
   * Determines if the ghost is in jail using the map 2D array
   * @return void
   */
  public boolean isInJail() {
    //Get the matrix positions of the ghost
    int corX = (this.getX()-8)/16; 
    int corY = (this.getY()-8)/16; 

    //Get the value of the tile and check if it is 5
    if (map.getTileNum(corX, corY) == 5) {
      return true;
    }

    //Else it is not in jail
    return false;
  }

  /**
   * Determines if the ghost is touching pacman
   * @return void
   */
  public void touchingPacman() {
    //Get the matrix positions of both pacman and ghost
    int pacX = (pac.getX()-8)/16; 
    int pacY = (pac.getY()-8)/16; 
    int corX = (this.getX()-8)/16; 
    int corY = (this.getY()-8)/16; 

    //If the ghost isn't in frenzy then pacman dies
    if (this.frenzy == false && corX == pacX && corY == pacY) {
      //Play the music for pacman's death
      death.play();
      delay(1000);
      pac.die();
      delay(300);
    } 
    //If the ghost touches pacman while in frenzyMode then the ghost gets eaten
    else if (this.eaten == false && this.frenzy == true && corX == pacX && corY == pacY) {
      this.eaten = true;
      //Set the jailCountDown to respective jailTime
      jailCountDown = jailTime;
      //Increment the score and play the sound effect for ghost's death
      score += 500;
      eatGhost.play();
      delay(500);
    }
  }


  /**
   * Determines whether or not a position is valid using the map 2D array
   * @param int x - x coordinate of a tile
   * @param int y - y cooridnate of a tile
   * @return boolean - true if valid, false if not valid
   */
  public boolean isValid(int x, int y) {
    //Get the tile num
    int temp = map.getTileNum(x, y);

    //If the tile is a wall or if the tile is out of bounds, then return false
    if (temp == 1 || temp == -1) {
      return false;
    } 
    //If the ghost is not eaten and is not in jail and if it encounters the door to the jail then return false
    else if (!this.isInJail() && this.eaten == false && temp == 4) {
      return false;
    } 

    //Otherwise return true
    return true;
  }

  /**
   * Changes the position vector depending on the most optimal option possible
   * @param int endX - x coordinate of a tile
   * @param int endY - y cooridnate of a tile
   * @return void
   */
  public void moveTowards(int endX, int endY) {
    //Calculating martix positions of ghost
    int corX = (this.getX()-8)/16; 
    int corY = (this.getY()-8)/16; 

    //Can only move if the timer is 0
    if (timer == 0) {
      //Variables for calculating the least manhattan distance (sum of delta x and delta y)
      int manDist = 99999999;
      //The second one is for backup to avaoid the ghosts from moving backwards
      int secManDist = 99999999;

      //Dist from each direction North, South, East, West
      int[] dist = new int[4];

      //Will store the index of the smallest dist from destination
      int index = -1;
      int secIndex = -1;

      //Right of the ghost
      dist[0] += Math.abs(this.getX()+16 - endX) + Math.abs(this.getY() - endY);
      //Left of the ghost
      dist[1] += Math.abs(this.getX()-16 - endX) + Math.abs(this.getY() - endY);
      //Up of the ghost
      dist[2] += Math.abs(this.getX() - endX) + Math.abs(this.getY()-16 - endY);
      //Down of the ghost
      dist[3] += Math.abs(this.getX() - endX) + Math.abs(this.getY()+16 - endY);

      //Find min distance from the dist array
      for (int i = 0; i < dist.length; i++) {
        //Have to make sure that the minimum dist tile isValid
        if (i == 0 && dist[i] < manDist && isValid(corX+1, corY)) {
          manDist = dist[i];
          index = i;
        } else if (i == 1 && dist[i] < manDist && isValid(corX-1, corY)) {
          manDist = dist[i];
          index = i;
        } else if (i == 2 && dist[i] < manDist && isValid(corX, corY-1)) {
          manDist = dist[i];
          index = i;
        } else if (i == 3 && dist[i] < manDist && isValid(corX, corY+1)) {
          manDist = dist[i];
          index = i;
        }
      }
      
      
      //Find back up min dist
      for (int i = 0; i < dist.length; i++) {
        if (i == 0 && dist[i] < secManDist && i != index && isValid(corX+1, corY)) {
          secManDist = dist[i];
          secIndex = i;
        } else if (i == 1 && dist[i] < secManDist && i != index && isValid(corX-1, corY)) {
          secManDist = dist[i];
          secIndex = i;
        } else if (i == 2 && dist[i] < secManDist && i != index && isValid(corX, corY-1)) {
          secManDist = dist[i];
          secIndex = i;
        } else if (i == 3 && dist[i] < secManDist && i != index && isValid(corX, corY+1)) {
          secManDist = dist[i];
          secIndex = i;
        }
      }

      //Find Direction of Travel
      if (index == 0 && dir[1] != 1) {//Right
        dir = new int[4];
        dir[0] = 1;
      } else if (index == 1 && dir[0] != 1) {//Left
        dir = new int[4];
        dir[1] = 1;
      } else if (index == 2 && dir[3] != 1) {//Up
        dir = new int[4];
        dir[2] = 1;
      } else if (index == 3 && dir[2] != 1) {//Down
        dir = new int[4];
        dir[3] = 1;
      } else { //This avoids the ghost from moving backwards in direction
        dir = new int[4];
        dir[secIndex] = 1;
      }

      //Move in that direction
      for (int i = 0; i < dir.length; i++) {
        if (dir[i] == 1) {
          if (i == 0) {
            pos.x = this.getX()+16;
            pos.y = this.getY();
            corX += 1;
          } else if (i == 1) {
            pos.x = this.getX()-16;
            pos.y = this.getY();
            corX -= 1;
          } else if (i == 2) {
            pos.x = this.getX();
            pos.y = this.getY()-16;
            corY -= 1;
          } else {
            pos.x = this.getX();
            pos.y = this.getY()+16;
            corY += 1;
          }
        }
      }
      
      //After moving the timer must be reset according to state
      //If the ghost is eaten then it quickly moves back to the jail
      if (this.frenzy == true && this.eaten == true) { 
        timer = 3;
      } 
      //If the ghost is only in frenzy mode then it moves slower
      else if (this.frenzy == true) {
        timer = 25;
      } 
      //Normal movement timer
      else {
        timer = 10;
      }
      //If the Tile the ghost is on is 6 then it must teleport
      if (map.getTileNum(corX, corY) == 6) {
        this.teleport();
      }
    }
  }
}
