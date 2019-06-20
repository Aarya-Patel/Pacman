/** 
 * PacManGame.pde
 * @author Aarya Patel
 * @version 1.0
 * January 20, 2019
 * This is the main class where all the components are utilized in parallel to create the game
 */

import java.io.*;
import java.util.*;
import processing.sound.*;
import controlP5.*;

/*Global Variables and objects*/

//Player Objects and Ghosts
PacMan pac;
Map map;
Ghost blinky;
Ghost pinky;
Ghost inky;
Ghost clyde;

//Score var
int score = 0;

//Player Name
String name = "";

//Writer to print to file
FileWriter output; 
//Booleans to display menus
boolean atStartMenu = true;
boolean atEndMenu = false;

//Print the Score only once
boolean printScore = false;

//Leaderboards array to store file contents (score, name)
String[] leaderboard = null;
String[][] leaderScore = new String[1000][1000];

//Images needed to display for the menus
PImage start;
PImage end;
PImage cont;

//Sound files for music and effects, used by other classes
SoundFile chomp;
SoundFile eatFruit;
SoundFile eatGhost;
SoundFile startMusic;
SoundFile death;
SoundFile frenzyMusic;

//GUI for user input
ControlP5 gui;

/** 
 * The setup method only runs once, this is where the objects are initialized
 * @return void
 */
public void setup() {
  //Map dimesions are 448*496
  size(448, 520);

  //Clock the frame rate to 100
  frameRate(100);

  //Initialize all the objects with thier coordinates
  pac = new PacMan();
  map = new Map();
  blinky = new Ghost(13, 12, 15, 255, 0, 0);
  pinky = new Ghost(15, 15, 50, 255, 105, 180);
  inky = new Ghost(13, 15, 100, 0, 255, 255);
  clyde = new Ghost(15, 12, 150, 255, 69, 0);

  //C:/Users/ANJANA PATEL/Documents/Processing/PacManGame/data/
  //Initialize the images for menus
  start = loadImage("StartMenu.png");
  end = loadImage("EndMenu.png");
  cont = loadImage("Continue.png");

  //Initialize the sound files for music and effects
  chomp = new SoundFile(this, "pacman_chomp.aiff");
  eatFruit = new SoundFile(this, "pacman_eatfruit.aiff");
  eatGhost = new SoundFile(this, "pacman_eatghost.aiff");
  startMusic = new SoundFile(this, "pacman_beginning.aiff");
  death = new SoundFile(this, "pacman_death.aiff");
  frenzyMusic = new SoundFile(this, "pacman_intermission.aiff");

  //Create the GUI to input the name
  createScreen();

  //Set the music amp to half
  startMusic.amp(0.5);
}


/** 
 * The draw method only runs continously. The game is put together in here.
 * Checks where the user is at the startMenu, endMenu or playing the game and displays the appropriate environment
 * @return void
 */
public void draw() {
  //Looping the music
  if (!startMusic.isPlaying() && !frenzyMusic.isPlaying()) {
    startMusic.play();
  }

  //Display startMenu is it is at the startMenu
  if (atStartMenu) {
    displayStartMenu();
  } else { //Otherwise go into the game
    //Make the startMusic quiter
    startMusic.amp(0.1);

    //Continously display the background image, map.jpg
    background(0);
    PImage m = loadImage("map.jpg"); 
    image(m, 0, 0);

    //Show the contents of the map: dot, bigDots, Cherry, etc.
    map.show();

    //Print Score and Lives
    printScore();
    printLives();

    //Show the ghosts
    blinky.show();
    pinky.show();
    inky.show();
    clyde.show();

    //Only play if pacman is alive
    if (pac.isAlive()) {

      //Show Pacman
      pac.show();

      //Tick methods are basically delay methods, but unlike delay it does not stop the program
      //Tick runs simulataneously, does not stop the program in real time
      pac.tick();
      blinky.tick();
      pinky.tick();
      inky.tick();
      clyde.tick();

      //Randomly display consumables(fruits)
      map.spawnCon();

      //Movement
      pac.playerMovement();
      blinky.move(pac.getX(), pac.getY());
      pinky.move((pac.getX()+96), pac.getY());
      inky.move(pac.getX()/2, pac.getY());
      clyde.move(pac.getX()-80, (pac.getY()));

      //Check for collisions
      blinky.touchingPacman();
      pinky.touchingPacman();
      inky.touchingPacman();
      clyde.touchingPacman();
    } else if (!pac.isAlive() && printScore == false) { //Once all three lives are gone, it must print the score along with name to the file
      //Credit to https://forum.processing.org/two/discussion/561/easiest-way-to-append-to-a-file-in-processing 
      try {
        //C:/Users/ANJANA PATEL/Documents/Processing/Code/PacManGame/leaderboard.txt
        //H:/Processing/Pacman/PacManGame/leaderboard.txt
        //Creating the file, MUST USE PATH WITH / not \, may have to manually input the path
        File file =new File("C:/Users/ANJANA PATEL/Documents/Processing/Code/PacManGame/leaderboard.txt");

        //Intialize the writers and append to the existing file
        output = new FileWriter(file, true); 
        BufferedWriter bw = new BufferedWriter(output);
        PrintWriter pw = new PrintWriter(bw);

        //Write the score and name to the file
        pw.println(score + " "+ name);
        pw.flush();
        pw.close();

        //Once this is done proceed to the endMenu
        atEndMenu = true;
        //Set printScore to false to avoid printing continously
        printScore = true;

        //Initalize the leaderboard array with the contents of the leaderboard.txt
        leaderboard = loadStrings("leaderboard.txt");
        for (int i = 0; i < leaderboard.length; i++) {
          leaderScore[i] = leaderboard[i].split(" ") ;
          //println(leaderboard[i]);
        }

        //Sort the user scores for displaying the leaderboards
        quickSort(leaderScore, 0, leaderboard.length);
      } //Catch the exception if the path is incorrect
      catch(IOException e) {
        e.printStackTrace();
      }
    }
  } 

  //Will display after the game is done
  if (atEndMenu) {
    //Display the endMenu 
    displayEndMenu();
  }
}

/** 
 * Once the mouse is clicked we proceed to the game. atStartMenu is assigned to false
 * @return void
 */
public void mouseClicked() {
  //As long as there is a name, register a click
  if (!name.equals("")) {
    this.atStartMenu = false;
  }
}

/** 
 * Displays the startMenu
 * @return void
 */
public void displayStartMenu() {
  //Display the start img 
  image(start, 0, 0);

  //Once there is a name, display the continue img
  if (!name.equals("")) {
    image(cont, 45, 465);
  }
}

/** 
 * Displays the endMenu
 * @return void
 */
public void displayEndMenu() {
  //Display the end img
  image(end, 0, 0);

  //Format text to display score and leaderboards
  textSize(20);
  fill(255, 255, 255);
  //Display user score
  text(score + " - " +name, 205, 140);

  //Display the top 5 scores from the leaderScore array which is sorted
  text(leaderScore[0][0] + " - " + leaderScore[0][1], 205, 265);
  text(leaderScore[1][0] + " - " + leaderScore[1][1], 205, 315);
  text(leaderScore[2][0] + " - " + leaderScore[2][1], 205, 365);

  //Scores 4 and 5 are smaller text size
  textSize(14);
  text(leaderScore[3][0] + " - " + leaderScore[3][1], 210, 415);
  text(leaderScore[4][0] + " - " + leaderScore[4][1], 210, 465);
}

/** 
 * Create the gui needed for inputting user name 
 * @return void
 */
public void createScreen() {
  //initialize the gui
  gui = new ControlP5(this);
  //Add the text field for inputting the name and format it
  gui.addTextfield("Enter your Name").setPosition(125, 390).setSize(200, 40).setFont(createFont("arail", 13)).setFocus(true).setColor(color(255, 255, 255));
  //Set the name to the inputted string
  name = gui.get(Textfield.class, "Enter your Name").getText();
}

/** 
 * Checks when enter is pressed for the textField in the gui
 * Automatically is called when enter is hit
 * @param ControlEvent theEvent, a controlEvent used when enter is pressed
 * @return void
 */
public void controlEvent(ControlEvent theEvent) {
  //If the event is caused by the Textfield.class then get the name
  if (theEvent.isAssignableFrom(Textfield.class)) {
    name = theEvent.getStringValue();
    //println(name);
  } 
  //This rejects null inputs
  if (!name.equals("")) {
    gui.dispose();
  }
}

/** 
 * Sorting method used for sorting the scores within the file
 * @param String[][]leaderScore, the 2D array of score and name
 * @param int low, the lower bound of the sort
 * @param int hi, the higher bound of the sort
 * @return void
 */
public void quickSort(String[][] leaderScore, int low, int hi) {
  //Makin sure that the indecies dont overlap
  if (low < hi) {
    //Partition the array around the pivot
    int index = partition(leaderScore, low, hi);
    //Recurse and sort the lower half and upper half
    quickSort(leaderScore, low, index-1);
    quickSort(leaderScore, index, hi);
  }
}

/** 
 * Sorting method used for sorting the scores within the file, paritions the array around a pivot
 * @param String[][]leaderScore, the 2D array of score and name
 * @param int low, the lower bound of the sort
 * @param int hi, the higher bound of the sort
 * @return The index of the partition 
 */
public int partition(String[][] leaderScore, int low, int hi) {
  //Pivot element is always the last one
  int pivot = int(leaderScore[hi-1][0]);
  int index = low;
  int current = low;
  //Arrange the elements around the pivot
  for (int i = current; i < hi; i++) {
    //Swap the array when the number is >= pivot, >= because I want it in decreasing order
    if (int(leaderScore[i][0]) >= pivot) {
      swap(leaderScore, i, index);
      index++;
    }
  }
  //Return the index of he last swapped position
  return index;
}

/** 
 * Swaps the arrays within a 2D array
 * @param String[][]leaderScore, the 2D array of score and name
 * @param int i, the index to be swapped
 * @param int j, the other index to be swapped
 * @return void
 */
public void swap(String[][] arr, int i, int j) {
  String[] temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

/** 
 * Prints the lives in the bottom left corner
 * @return void
 */
public void printLives() {
  //Loop through the number of lives pacman has and print a circle
  for (int i = 0; i < pac.getLives(); i++) {
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse(16 + i * 32, 505, 16, 16);
  }
}

/** 
 * Prints the score in the bottom middle of the screen
 * @return void
 */
public void printScore() {
  textSize(20);
  fill(255, 255, 255);
  text(score, 208, 510);
}
