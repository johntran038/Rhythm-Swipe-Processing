/*/
 Game Project
 Rhythm Swipe
 Processing Edition
 
 Legends:
 - !!!: Variable restart in Finish or Failed function
 https://stackoverflow.com/questions/58463931/smooth-movement-in-processing
/*/
import java.util.*;
import processing.sound.*;
import processing.serial.*;

//Buttons
Button EasyMode;
Button NormalMode;
Button HardMode;
Button MasterMode;

Button EasyStart;
Button NormalStart;
Button HardStart;
Button MasterStart;

Button ReturnButton;


//CLASSES GLOBAL VARIABLES
public static int rpos;
public static int rpos2;
public static int random;

//------------John's Code-----------

String myString;
Serial mySerial;
int nl = 10;


//------------MainMenu--------------
PImage BackgroundImage; //Main menu background
Cube NPCS; //
int rectWidthMainMenu = 30;
int rectHeightMainMenu = 500;
int xMainMenu = rectWidthMainMenu; //!!!
int yMainMenu = 575;
SoundFile MainMenuTheme;
boolean MainMenuThemeSwitch = false;
//----------------------------------

//---------------Creating the Board-------------------
int boardSize = 600; //How big the board is
int tileSize = boardSize/10; //The grid

int difficultyMoveLimit; //How far can the enemy go
//----------------------------------------------------



//-----------------The Character----------------------
float moveWidth = 0; //!!!
float moveHeight = 0; //!!!
Player player; //The player !!!
PImage[] playerAnimation; //List of images to use for the character "REMOVED "= []"
int playerCounter = 0; //!!!
int backgroundColor = 210; //The background color of the board. !!! //210
//----------------------------------------------------



//------------------Enemies (Work in progress)-------------------------------
//"REMOVED = []"


//"REMOVED = []"
PImage[] guard; //Images of the guard
boolean canMove = false; //!!!

//Use these variables to check collision with a player
//---------------------------------------------------------------------------



//-------------------------------The bar that detects the beat in game. (Work in progress)-------------------
int pressByBeat = 255;
//cubeDetector and cubeBeat has been moved
int rectWidth = 28;
int rectHeight = 500;


int x2 = rectWidth; //!!!
int x21 = rectWidth + 113; //!!
int x22 = rectWidth + 213; //!!
int x23 = rectWidth + 313; //!!
int x24 = rectWidth + 413; //!!
int x25 = rectWidth + 513; //!!


int y2 = 575;
//-----------------------------------------------------------------------------------------------------------



//--------------------Timer for Master Mode---------------------------
//Timer used to see how long the player takes to complete a level.
//Will be used in the Master Mode!!!!!
int timer = 0; //!!!
int worldRecord = -1; //-1 is null
boolean masterModeTimer = false; //!!!
//--------------------------------------------------------------------



//------------------------Items in game-------------------------------
//REMOVED = []
Coins[] coins; //!!!
PImage[] diamonds = new PImage[4]; //Our "coins" images
Block[] blocks; //!!!

int points = 0; //!!!
int i = 0; //!!!
int level = 1; //Can change any level for testing purposes (-1 by default)
//--------------------------------------------------------------------


//------------------Green block (Finish line)-------------------------
int[] finishLine = new int[2]; //!!! "REMOVED "= []"
FinishBlock endBlock; //!!!
//--------------------------------------------------------------------




//-----------------------Music for all 4 levels!----------------------
SoundFile easySound;
SoundFile normalSound;
SoundFile hardSound;
SoundFile masterSound;



Amplitude amplitude = new Amplitude(this);
ArrayList<Float> volHistory = new ArrayList<>(); //!!! in main menu "REMOVED " = []"


//----------------------Music Related------------------------------

Cube cubeDetector = new Cube();
Cube cubeBeat = new Cube();
//-----------------------------------------------------------------
//--------------------------------------------------------------------




//--------------------------------------------------------------------SETUP---------------------------------------------------------------------------------
//Creation of the Canvas, the buttons, and the sounds
void setup() {
  size(600, 600);
  
  String myPort = Serial.list()[0];
  println(Serial.list());
  mySerial = new Serial(this, myPort, 9600);
  
  //div.position(100, 100);
  //div.center("horizontal");
  NPCS = new Cube();
  
  //Buttons
  //MainMenu
  EasyMode = new Button(width/3.2, height/5, 125, "Easy", color(54, 178, 9)); //Done
  NormalMode = new Button(width/3.2, height/2.8, 125, "Normal", color(255, 232, 26));
  HardMode = new Button(width/3.2, height/1.95, 125, "Hard", color(233, 111, 18));
  MasterMode = new Button(width/3.2, height/1.5, 125, "Master", color(233, 32, 18));
  
  //Intermissions
  EasyStart = new Button(width/3.2, height/1.7, 125, "Start", color(54, 178, 9)); //Done
  NormalStart = new Button(width/3.2, height/1.7, 125, "Start", color(255, 232, 26));
  HardStart = new Button(width/3.2, height/1.7, 125, "Start", color(233, 111, 18));
  MasterStart = new Button(width/3.2, height/1.7, 125, "Start", color(233, 32, 18));
    
    
    
  //General Return Button
  ReturnButton = new Button(width/3.2, height/1.3, 125, "Return", color(168, 165, 152));
  
  //Initially show the Main Menu buttons
  ReturnButton.visible = false;
  EasyStart.visible = false;
  NormalStart.visible = false;
  HardStart.visible = false;
  MasterStart.visible = false;
  
  //TASK: WORK ON THE MUSIC TO DISPLAY CORRECTLY
  //*/Sounds//
   easySound = new SoundFile(this, "./sounds/A_Punchup_at_a_Wedding_8-bit.mp3");
   //*/
  //*/Sounds//
   normalSound = new SoundFile(this, "./sounds/There_There_8-bit.mp3");
   //*/
  //*/Sounds//
   hardSound = new SoundFile(this, "./sounds/Where_I_End_You_Begin_8-bit.mp3");
   //*/
    //*/Sounds//
   masterSound = new SoundFile(this, "./sounds/Super_Mario_Galaxy.mp3");
   //*/

  //*/Sounds//
   MainMenuTheme = new SoundFile(this, "./sounds/Main8-bit.mp3");
  MainMenuTheme.play();
  //*/
  //TASK: ITS ANIMATION

  playerAnimation = new PImage[12];
  //Thief Images
  for (int i = 0; i < 12; i++) {
    playerAnimation[i] = loadImage("asset/thief/Thief"+i+".png");
    println("Sprite Thief loaded");
  }

  //Guard Images
  guard = new PImage[16];
  for (int i = 0; i < 16; i++) {
    if (i >= 12) {
      guard[i] = loadImage("asset/guard/Guard"+i+".gif");
    } else {
      guard[i] = loadImage("asset/guard/Guard"+i+".png");
    }
    println("Sprite Guard loaded");
  }

  //Diamond Images
  for (int i = 0; i < 4; i++) {
    diamonds[i] = loadImage("asset/gems/gem"+i+".png");
    println("Items loaded");
  }

  BackgroundImage = loadImage("asset/MainMenu.gif");





  //TASK: CREATE THE BUTTONS
}






boolean updated = false;
boolean drawFlag = false;

boolean easyFlag = false;
boolean normalFlag = false;
boolean hardFlag = false; //might want to set these flags to true when you want press the "play again"
boolean masterFlag = false;

Enemy[] enemies;
void draw() {
  
  //EDIT WE CHANGED THE CASES BTW
  //println(masterModeTimer);
  //TASK: REWORK ON THE ROOMS (SWITCH CASES)
  switch(level) {
    
    case 1://Main menu
      image(BackgroundImage, 0, 0, boardSize, boardSize);
      fill(255, 202, 48);
      textSize(72);
      text("Rhythm Swipe", 85, 100);
      showNPC(); //A nice seeing of a cop running to the robber
      EasyMode.visible = true;
      NormalMode.visible = true;
      HardMode.visible = true;
      MasterMode.visible = true;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      break;
    case 2: //Easy Mode
      difficultyMoveLimit = 4;
      if (!easyFlag) {
        if (player == null) {
          player = new Player(2, 8);
          playerCounter = 3;
          //NEW
          //player.turn(90);
          /*/Sounds/
           normalSound.play();
          //*/
          canMove = true;
        }
        
        if(coins == null){
           coins = new Coins[3];
        }
        if (blocks == null){
           blocks = new Block[16];
        }
        level1Beat();
        drawBoard();
        easyRoom();
        board();
        finished();
        easyFlag = true;
      }
      break;
    case 3: //Normal Mode
      difficultyMoveLimit = 4;
      if (!normalFlag) {
        if (player == null) {
          player = new Player(3, 4);
          playerCounter = 2;
          //NEW
          //player.turn(90);
          /*/Sounds/
           normalSound.play();
          //*/
          canMove = true;
        }
        
        if(coins == null){
           coins = new Coins[3];
        }
        if (blocks == null){
           blocks = new Block[41];
        }
        level2Beat();
        drawBoard();
        normalRoom();
        board();
        finished();
        enemies = new Enemy[2];
        enemies[0] = new Enemy(4, 2, false, true);
        enemies[1] = new Enemy(2, 8, false, true);
        normalFlag = true;
      }
      break;
    case 4: //Hard Mode (Use this as template
      difficultyMoveLimit = 3;
      if (!hardFlag) {
        if (player == null) {
          player = new Player(7, 11);
          playerCounter = 0;
          //player.turn(-90);
  
          //println(player);
          //NEW
          /*/Sounds/
          hardSound.play();
          //*/
          canMove = true;
        }
        if (coins == null){
          coins = new Coins[5];
        }
        if (blocks == null){
          blocks = new Block[35];
        }
      
        level3Beat();
        drawBoard();
        hardRoom();
        board();
        finished();
        enemies = new Enemy[5];
        enemies[0] = new Enemy(5, 3, false, true);
        enemies[1] = new Enemy(6, 7, false, true);
        enemies[2] = new Enemy(2, 7, false, true);
        //Y-axis
        enemies[3] = new Enemy(4, 3, false, false);
        enemies[4] = new Enemy(8, 3, false, false);
        hardFlag = true;
      }
      break;
    case 5: //MasterMode
      difficultyMoveLimit = 4;
      if (!masterFlag) {
        if (player == null) {
          player = new Player(2, 8);
          //NEW
          /*/Sounds/
           masterSound.play();
          //*/
          canMove = true;
        }
        if (coins == null){
          coins = new Coins[5];
        }
        if (blocks == null){
          blocks = new Block[34];
        }
      
        level4Beat();
        drawBoard();
        masterRoom();
        board();
        finished();
        enemies = new Enemy[5];
        enemies[0] = new Enemy(3, 2, false, true);
        enemies[1] = new Enemy(4, 10, false, true);
        //Y-axis
        enemies[2] = new Enemy(5, 4, false, false);
        enemies[3] = new Enemy(9, 2, false, false);
        enemies[4] = new Enemy(9, 5, false, false);
        masterFlag = true;
      }
      break;
  }

  //SAFE ZONE: DRAW WILL NOT SPAM HERE
  //UPDATES AFTER COLLIDE
  if (!drawFlag||(!updated && !boxCollided())) {
    updated = true;
    drawFlag = true;
    switch(level) {
    case 1: //(DONE FOR NOW)
      //buttonBack.hide();
      //StartGameButton.hide();
      //buttonW.hide();
      //buttonStart.hide();
      //button2Start.hide();
      //button3Start.hide();
      //button4Start.hide();

      /*//Sounds
       easySound.stop();
       normalSound.stop();
       hardSound.stop();
       masterSound.stop();
       //*/

      EasyMode.visible = true;
      NormalMode.visible = true;
      HardMode.visible = true;
      MasterMode.visible = true;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      /*//
       if (MainMenuThemeSwitch == false && !MainMenuTheme.isPlaying()){
       MainMenuTheme.play();
       MainMenuTheme.loop();
       MainMenuThemeSwitch = true;
       }
       //*/
      background(0, 0, 0, 255); //black
      
      image(BackgroundImage, 0, 0, boardSize, boardSize);

      fill(255, 202, 48);
      textSize(50);
      text("Rhythm Swipe", 144, 100);
      //buttonShow();
      break;
      //------------------------------------------



      //--------------Easy Mode-------------------
    case -2: //Easy Mode Intermission (DONE)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209); //gray
      //buttonHide();

      fill(0);
      textSize(25);
      text("Difficulty: Easy", 25, 100);
      textSize(20);
      text("Music: A Punch Up at a Wedding", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio(); //Show the audio visually
      break;
    case 2: //Easy Mode Level (DONE FOR NOW)
      //buttonHide();
      if (player == null) {
        player = new Player(2, 8);
        playerCounter = 3;
        //NEW
        coins = new Coins[3];
        blocks = new Block[16];
        /*/Sounds/
         easySound.play();
        //*/
        canMove = true;
      }

      drawBoard();
      easyRoom();
      board();
      finished();
      break;
      //-----------------------------------------



      //-------------Normal Mode-----------------
    case -3: //Normal Mode Intermission (DONE FOR NOW)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);
      //buttonHide();

      fill(0);
      textSize(25);
      text("Difficulty: Normal", 25, 100);
      textSize(20);
      text("Music: There There", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio();
      break;
    case 3: //Normal Mode Level (DONE FOR NOW)
      //buttonHide();
      if (player == null) {
        player = new Player(3, 4);
        playerCounter = 2;
        //NEW
        coins = new Coins[3];
        blocks = new Block[41];
        //player.turn(90);
        /*/Sounds/
         normalSound.play();
        //*/
        canMove = true;
      }

      drawBoard();
      normalRoom();
      board();
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].move();
      }
      finished();
      break;
      //-----------------------------------------





      //---------------Hard Mode-----------------USE THIS AS TEMPLATE------------------------------------------------------------------------------
    case -4: //Hard Mode Intermission (DONE FOR NOW)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);
      //buttonHide();

  
      fill(0);
      textSize(25);
      text("Difficulty: Hard", 25, 100);
      textSize(20);
      text("Music: Where I End and You Begin", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio();
      break;
    case 4: //Hard Mode Level (USE THIS AS TEMPLATE)
      //buttonHide();
      if (player == null) {
        player = new Player(7, 11);
        playerCounter = 0;
        //player.turn(-90);

        //println(player);
        //NEW
        coins = new Coins[5];
        blocks = new Block[35];
        /*/Sounds/
        hardSound.play();
        //*/
        canMove = true;
      }
      

      drawBoard();
      hardRoom();
      board();
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].move();
      }
      finished();
      break;
      //-------------------------------------------------------------------------------


      //--------------Master Mode-------------------
    case -5: //Master Mode Intermssion (DONE FOR NOW)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);
      //buttonHide();
      
    
      
      
      fill(0);
      textSize(25);
      text("Difficulty: Master", 25, 100);
      textSize(20);
      text("Music: Super Mario Galaxy: Staff Roll 8 Bit Remix", 25, 150);
      text("By Vahkiti", 25, 200);
      if (worldRecord == -1) {
        text("Creative Coding Current Fastest Time: None", 20, 600);
      } else {
        text("Creative Coding Current Fastest Time: "+worldRecord+"s", 20, 600);
      }
      visualAudio();
      break;
    case 5: //Master Mode Level (DONE FOR NOW)
      //buttonHide();
      if (player == null) {
        player = new Player(2, 8);
        //NEW
        coins = new Coins[5];
        blocks = new Block[34];
        /*/Sounds/
         masterSound.play();
        //*/
        canMove = true;
      }
      drawBoard();
      masterRoom();
      board();
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].move();
      }
      finished();
      break;
      //-------------------------------------------
    }
  } else if (boxCollided()) {
    updated = false;
  }
  
  
  
  //Another switch level cases to display stuff in general
  switch(level) {
    case 1://Main menu
      image(BackgroundImage, 0, 0, boardSize, boardSize);
      fill(255, 202, 48);
      textSize(72);
      text("Rhythm Swipe", 85, 100);
      showNPC(); //A nice seeing of a cop running to the robber
      //Initially show the Main Menu buttons
      EasyMode.visible = true;
      NormalMode.visible = true;
      HardMode.visible = true;
      MasterMode.visible = true;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      //Show the buttons in main Menu
      if (EasyMode.visible){
        EasyMode.show();
      }
      if (NormalMode.visible){
        NormalMode.show();
      }
      if (HardMode.visible){
        HardMode.show();
      }
      if (MasterMode.visible){
        MasterMode.show();
      }
      
      break;
    case -2: //Easy Mode Intermission (DONE)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209); //gray
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = true;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      
      //Show the Start and Back button
      if (EasyStart.visible){
        EasyStart.show();
      }
      if (ReturnButton.visible){
        ReturnButton.show();
      }

      
      
      
      fill(0);
      textSize(25);
      text("Difficulty: Easy", 25, 100);
      textSize(20);
      text("Music: A Punch Up at a Wedding", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio(); //Show the audio visually
      break;
    case 2: //Easy
      //if (player == null) {
      //  player = new Player(2, 8);
      //  playerCounter = 3;
      //  //NEW
      //  coins = new Coins[3];
      //  blocks = new Block[16];
      //  /*/Sounds/
      //   easySound.play();
      //  //*/
      //  canMove = true;
      //}
      drawBoard();
      easyRoom();
      board();
      player.display();
      level1Beat();
      finished();
      break;
    case -3: //Normal Mode Intermission (DONE)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);

      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = true;
      HardStart.visible = false;
      MasterStart.visible = false;

      if (NormalStart.visible){
        NormalStart.show();
      }
      if (ReturnButton.visible){
        ReturnButton.show();
      }

      fill(0);
      textSize(25);
      text("Difficulty: Normal", 25, 100);
      textSize(20);
      text("Music: There There", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio();
      break;
    case 3: //Normal
      drawBoard();
      normalRoom();
      board();
      player.display();
      level2Beat();
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].display();
      }
      finished();
      break;
    case -4: //Hard Mode Intermission (DONE FOR NOW)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = true;
      MasterStart.visible = false;



      if (HardStart.visible){
        HardStart.show();
      }
      if (ReturnButton.visible){
        ReturnButton.show();
      }

      fill(0);
      textSize(25);
      text("Difficulty: Hard", 25, 100);
      textSize(20);
      text("Music: Where I End and You Begin", 25, 150);
      text("By Radiohead", 25, 200);
      visualAudio();
      break;
    case 4: //Hard
      drawBoard();
      hardRoom();
      board();
      player.display();
      level3Beat();
      for (int i = 0; i < enemies.length; i++) {
        enemies[i].display();
      }
      
      
      //drawBoard();
      //hardRoom();
      //board();
      //finished();
      //player.display();
      //level3Beat();
      finished();
      break;
    case -5: //Master Mode Intermssion (DONE)
      //MainMenuTheme.stop();
      //MainMenuThemeSwitch = false;
      background(209);
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = true;
      
      if (MasterStart.visible){
        MasterStart.show();
      }
      if (ReturnButton.visible){
        ReturnButton.show();
      }
      
      fill(0);
      textSize(25);
      text("Difficulty: Master", 25, 100);
      textSize(20);
      text("Music: Super Mario Galaxy: Staff Roll 8 Bit Remix", 25, 150);
      text("By Vahkiti", 25, 200);
      if (worldRecord == -1) {
        text("Creative Coding Current Fastest Time: None", 20, 580);
      } else {
        text("Creative Coding Current Fastest Time: "+worldRecord+"s", 20, 580);
      }
      visualAudio();
      break;
    case 5: //Master //TEMPLATE
        drawBoard();
        masterRoom();
        board();
        player.display();
        level4Beat();
        for (int i = 0; i < enemies.length; i++) {
          enemies[i].display();
        }
        
        
        //We time the player now
        masterModeTimer = true;
        if (frameCount % 30 == 0 && timer >= 0) {
          timer++;
        }
        finished();
      break;
      
      
      
      //Either win or lose
    case 6: //Mission accomplished with Stats
        background(41, 199, 62); //green
        fill(243, 206, 19); //gold
        textSize(50);
        text("Mission Success", boardSize/4.6, 100);
        //Master code
        if (masterModeTimer == true) {
          if (worldRecord == -1 || worldRecord > timer) {
            text("Finish Time: "+timer+"s", boardSize/4.5, 200);
            text("New World Record!", boardSize/6.3, 300);
          } else {
            text("Finish Time: "+timer+"s", boardSize/4.5, 200);
            textSize(25);
            text("Creative Coding Exhibition Fastest Time: "+worldRecord+"s", boardSize/8, 300);
          }
        }
        ReturnButton.visible = true;
        if (ReturnButton.visible){
          ReturnButton.show();
        }
        break;
     case 7: //Mission Failed
        background(255, 0, 0, 255); //red
        fill(0);
        textSize(50);
        text("Mission Failed", boardSize/4.3, 100);
        //buttonW.show();
        //buttonHide();
        failed();
        ReturnButton.visible = true;
        if (ReturnButton.visible){
          ReturnButton.show();
        }
        break;
        //------------------
    }

  while(mySerial.available()>0){
    myString = mySerial.readStringUntil(nl);
    if(myString != null){
      myString = myString.strip();
      println(myString);
      
      //if(myString.equals("cal")){
      //  println("les go");
      //}
      
      if (canMove){
        if (myString.equals("ccw")) {
          // moveWidth -= tileSize;
          playerCounter-= 1;
          counterRevise();
          player.turn();
          //println("left");
        } else if (myString.equals("cw")) {
          // moveWidth += tileSize;
          playerCounter+= 1;
          counterRevise();
          player.turn();
          //println("right");
        }
        if(myString.equals("move")){
          println("les go");
          player.move();
          pressByBeat = 0;
          //println("space");
        }
    //  if (keyCode == LEFT) {
    //    // moveWidth -= tileSize;
    //    playerCounter-= 1;
    //    counterRevise();
    //    player.turn();
    //    //println("left");
    //  } else if (keyCode == RIGHT) {
    //    // moveWidth += tileSize;
    //    playerCounter+= 1;
    //    counterRevise();
    //    player.turn();
    //    //println("right");
    //  } else if (keyCode == ' ') { //Space bar
    //    player.move();
    //    pressByBeat = 0;
    //    //println("space");
    //  }
      }
    }
  }
    
//Danger zone
}
//---------------------

void mousePressed() {
  if (EasyMode.visible) { // Don't process click if button is disabled    
    if (mouseX >= EasyMode.pos.x && mouseX <= EasyMode.pos.x + EasyMode.size + 100 && 
      mouseY >= EasyMode.pos.y && mouseY <= EasyMode.pos.y + EasyMode.size - 40){
      // User has clicked the button! Do something!
      level = -2;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = true;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("EasyIntermission");
      easySound.play();
       normalSound.stop();
      hardSound.stop();
      masterSound.stop();
      
      MainMenuTheme.stop();
    } 
  }
  if (NormalMode.visible) { // Don't process click if button is disabled    
    if (mouseX >= NormalMode.pos.x && mouseX <= NormalMode.pos.x + NormalMode.size + 100 && 
      mouseY >= NormalMode.pos.y && mouseY <= NormalMode.pos.y + NormalMode.size - 40){
      // User has clicked the button! Do something!
      level = -3;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = true;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("NormalIntermission");
      
      easySound.stop();
      normalSound.play();
      hardSound.stop();
      masterSound.stop();
      
      MainMenuTheme.stop();
    } 
  }
  if (HardMode.visible) { // Don't process click if button is disabled    
    if (mouseX >= HardMode.pos.x && mouseX <= HardMode.pos.x + HardMode.size + 100 && 
      mouseY >= HardMode.pos.y && mouseY <= HardMode.pos.y + HardMode.size - 40){
      // User has clicked the button! Do something!
      level = -4;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = true;
      MasterStart.visible = false;
      println("HardIntermission");
      //*/Sounds/
      easySound.stop();
      normalSound.stop();
      hardSound.play();
      masterSound.stop();
      
      MainMenuTheme.stop();
      //*/
    } 
  }
  if (MasterMode.visible) { // Don't process click if button is disabled    
    if (mouseX >= MasterMode.pos.x && mouseX <= MasterMode.pos.x + MasterMode.size + 100 && 
      mouseY >= MasterMode.pos.y && mouseY <= MasterMode.pos.y + MasterMode.size - 40){
      // User has clicked the button! Do something!
      level = -5;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = true;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = true;
      println("MasterIntermission");
      easySound.stop();
      normalSound.stop();
      hardSound.stop();
      masterSound.play();
      
      MainMenuTheme.stop();
    } 
  }
  if (EasyStart.visible) { // Don't process click if button is disabled    
    if (mouseX >= EasyStart.pos.x && mouseX <= EasyStart.pos.x + EasyStart.size + 100 && 
      mouseY >= EasyStart.pos.y && mouseY <= EasyStart.pos.y + EasyStart.size - 40){
      // User has clicked the button! Do something!
      level = 2;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("Start Easy!");
      easySound.stop();
      easySound.play();
      normalSound.stop();
      hardSound.stop();
      masterSound.stop();
      
      MainMenuTheme.stop();
    } 
  }
  if (NormalStart.visible) { // Don't process click if button is disabled    
    if (mouseX >= NormalStart.pos.x && mouseX <= NormalStart.pos.x + NormalStart.size + 100 && 
      mouseY >= NormalStart.pos.y && mouseY <= NormalStart.pos.y + NormalStart.size - 40){
      // User has clicked the button! Do something!
      level = 3;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("Start Normal!");
      easySound.stop();
      normalSound.stop();
      normalSound.play();
      hardSound.stop();
      masterSound.stop();
      
      MainMenuTheme.stop();
    } 
  }
  if (HardStart.visible) { // Don't process click if button is disabled    
    if (mouseX >= HardStart.pos.x && mouseX <= HardStart.pos.x + HardStart.size + 100 && 
      mouseY >= HardStart.pos.y && mouseY <= HardStart.pos.y + HardStart.size - 40){
      // User has clicked the button! Do something!
      level = 4;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("Start Hard!");
      easySound.stop();
      normalSound.stop();
      hardSound.stop();
      hardSound.play();
      masterSound.stop();
      
      MainMenuTheme.stop();
    } 
  }
  if (MasterStart.visible) { // Don't process click if button is disabled    
    if (mouseX >= MasterStart.pos.x && mouseX <= MasterStart.pos.x + MasterStart.size + 100 && 
      mouseY >= MasterStart.pos.y && mouseY <= MasterStart.pos.y + MasterStart.size - 40){
      // User has clicked the button! Do something!
      level = 5;
      EasyMode.visible = false;
      NormalMode.visible = false;
      HardMode.visible = false;
      MasterMode.visible = false;
      ReturnButton.visible = false;
      
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("Start Master!");
      easySound.stop();
      normalSound.stop();
      hardSound.stop();
      masterSound.stop();
      masterSound.play();
      MainMenuTheme.stop();
    } 
  }
  if (ReturnButton.visible) { // Don't process click if button is disabled    
    if (mouseX >= ReturnButton.pos.x && mouseX <= ReturnButton.pos.x + ReturnButton.size + 100 && 
      mouseY >= ReturnButton.pos.y && mouseY <= ReturnButton.pos.y + ReturnButton.size - 40){
      // User has clicked the button! Do something!
      level = 1;
      EasyMode.visible = true;
      NormalMode.visible = true;
      HardMode.visible = true;
      MasterMode.visible = true;
      ReturnButton.visible = false;
      EasyStart.visible = false;
      NormalStart.visible = false;
      HardStart.visible = false;
      MasterStart.visible = false;
      println("Return!");
      easySound.stop();
      normalSound.stop();
      hardSound.stop();
      masterSound.stop();
      MainMenuTheme.play();
    } 
  }
  
  
  //Retry button?
  
  
}






//--------------------------------------------------------------------Display the Music Beat Bar------------------------------------------------------------
void showNPC() {
  NPCS.displayMainMenu();
}

//Beat based on the theme of the song
void level1Beat() {
  cubeBeat.displayLevel1();
}
//Level2
void level2Beat() {
  cubeBeat.displayLevel2();
}
//Level3
void level3Beat() {
  cubeBeat.displayLevel3();
}
//Levelmaster
void level4Beat() {
  cubeBeat.displayLevel4();
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------












//-------------------------------------------------------------------------FINISH OR FAILED LEVEL-------------------------------------------------------------------------------
//Finish the level or not, clear everything!

void finished() {
  float finishX = finishLine[0] + 60;
  float finishY = finishLine[1] - 120;
  if (moveWidth == finishX && moveHeight == finishY && coins.length == points) { //If it collides with the endBlock
    println("Winner!");
    level = 6;

    playerCounter = 0; //
    //Clear everything when level complete
    moveWidth = 0; //
    moveHeight = 0; //
    points = 0; //
    backgroundColor = 210; //
    player = null; //
    enemies = null;
    x2 = rectWidth; //
    x21 = rectWidth + 113; //!!
    x22 = rectWidth + 213; //!!
    x23 = rectWidth + 313; //!!
    x24 = rectWidth + 413; //!!
    x25 = rectWidth + 513; //!!
    i = 0; //
    //finishLine = empty; //[]
    coins = null; //[]
    blocks = null; //[]
    endBlock = null; //
    easyFlag = false;
    normalFlag = false;
    hardFlag = false;
    masterFlag = false;
    //*/Sounds/
     easySound.stop();
     //*/
    //*/Sounds/
     normalSound.stop();
     //*/
    //*/Sounds/
     hardSound.stop();
     //*/
    //*/Sounds/
     masterSound.stop();
     //*/
    canMove = false; //
    if (masterModeTimer == true) {
      if (worldRecord > timer || worldRecord == -1) {
        worldRecord = timer;
      }
    }
    masterModeTimer = false;
    timer = 0;
    difficultyMoveLimit = 0;
  }
}
void failed() {
  //console.log("Winner!");
  //Clear everything when level complete
    playerCounter = 0; //
    //Clear everything when level complete
    moveWidth = 0; //
    moveHeight = 0; //
    points = 0; //
    backgroundColor = 210; //
    player = null; //
    enemies = null;
    x2 = rectWidth; //
    x21 = rectWidth + 113; //!!
    x22 = rectWidth + 213; //!!
    x23 = rectWidth + 313; //!!
    x24 = rectWidth + 413; //!!
    x25 = rectWidth + 513; //!!
    i = 0; //
    //finishLine = empty; //[]
    coins = null; //[]
    blocks = null; //[]
    endBlock = null; //
    easyFlag = false;
    normalFlag = false;
    hardFlag = false;
    masterFlag = false;
    //*/Sounds/
     easySound.stop();
     //*/
    //*/Sounds/
     normalSound.stop();
     //*/
    //*/Sounds/
     hardSound.stop();
     //*/
    //*/Sounds/
     masterSound.stop();
    //*/
    canMove = false; //
    
    masterModeTimer = false;
    timer = 0;
    difficultyMoveLimit = 0;
}
//----------------------------------------------------------------------------------------------------------------------------------------------------------




//--------------------------------------------------------------------LEVEL Intermission => Actual Level-------------------------------------------------------------------------------



//Show the audio throughout all Difficulty Levels
void visualAudio() {
  float vol = amplitude.analyze();

  volHistory.add(vol);
  
  //if(volHistory.size() > width*1){
  //  volHistory = splice(<Float>volHistory, (float)0, 1);
  //}

  stroke(255);
  noFill();
  beginShape();
  for (int i=0; i<volHistory.size(); i++) {
    float y = map(volHistory.get(i), 0, 1, height/2, 0); //position map
    vertex(i, y);
  }
  endShape();

  stroke(255, 0, 0);
  line(volHistory.size(), 0, volHistory.size(), height);
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------











//----------------------------------------------------------------BUTTON HIDE AND SHOW--------------------------------------------------------------
void mainMenu() {
  volHistory = null; //Reset the visual for music []
  level = 0;
  //buttonW.hide();
  //buttonBack.hide();
  //Temporary for now
  if (masterModeTimer == true) {
    if (worldRecord > timer || worldRecord == -1) {
      worldRecord = timer;
    }
  }
  masterModeTimer = false;
  timer = 0;
  //-----------------
}
//-------------------------------------------------------------------------------------------------------------------------------------







//---------------------------------------------------------LEVEL DESIGN-------------------------------------------------------------------

//Shows all the levels on screen when button is clicked!
void easyRoom() { //Done
  finishLine[0] = 540;
  finishLine[1] = 300;

  //randomCoinX = random([30, 90, 150, 210, 270, 330, 390, 450, 510, 570]);
  //randomCoinY = random([30, 90, 150, 210, 270, 330, 390, 450, 510, 570]);


  //coins display
  //I am not sure why the loop needs to be here
  //since it will not work if there is no loop here.

  //Best guess: It requires to update in a scope scene since
  //The player needs to collect the coins and the coins will position
  //else where.
  while (i != 1) {
    coins[0] = new Coins(150, 210, random(0, 3));
    coins[1] = new Coins(150, 330, random(0, 3));
    coins[2] = new Coins(570, 270, random(0, 3));
    i++;
  }

  //The blocks does not need a loop since it is in a static position
  //Points boarder (Coins)
  blocks[0] = new Block(30, 30);
  blocks[1] = new Block(90, 30);
  blocks[2] = new Block(150, 30);

  //Borders
  blocks[3] = new Block(570, 210);
  blocks[4] = new Block(90, 270);
  blocks[5] = new Block(150, 270);
  blocks[6] = new Block(210, 270);
  blocks[7] = new Block(270, 270);
  blocks[8] = new Block(330, 270);
  blocks[9] = new Block(390, 270);
  blocks[10] = new Block(450, 270);
  blocks[11] = new Block(510, 270);
  blocks[12] = new Block(510, 210);
  blocks[13] = new Block(510, 330);
  blocks[14] = new Block(90, 210);
  blocks[15] = new Block(90, 330);

  //The goal line
  endBlock = new FinishBlock(finishLine[0], finishLine[1]);
}



void normalRoom() { //Normal mode
  finishLine[0] = 540;
  finishLine[1] = 300;
  while (i != 1) {
    //array = random([30, 90, 150, 210, 270, 330, 390, 450, 510, 570]);
    //array2 = random([30, 90, 150, 210, 270, 330, 390, 450, 510, 570]);
    coins[0] = new Coins(570, 450, random(0, 3));
    coins[1] = new Coins(270, 270, random(0, 3));
    coins[2] = new Coins(210, 30, random(0, 3));
    i++;
  }




  //Points boarder (Coins)
  blocks[0] = new Block(30, 30);
  blocks[1] = new Block(90, 30);
  blocks[2] = new Block(150, 30);


  //borders
  blocks[3] = new Block(150, 390);
  blocks[4] = new Block(150, 450);
  blocks[5] = new Block(150, 510);
  blocks[6] = new Block(30, 390);
  blocks[7] = new Block(30, 450);
  blocks[8] = new Block(30, 510);

  blocks[9] = new Block(30, 210);
  blocks[10] = new Block(90, 210);
  blocks[11] = new Block(150, 210);
  blocks[12] = new Block(210, 210);
  blocks[13] = new Block(270, 210);
  blocks[14] = new Block(330, 210);

  blocks[15] = new Block(330, 270);
  blocks[16] = new Block(330, 330);
  blocks[17] = new Block(330, 390);
  blocks[18] = new Block(330, 450);

  blocks[19] = new Block(390, 270);
  blocks[20] = new Block(390, 330);
  blocks[21] = new Block(390, 390);
  blocks[22] = new Block(390, 450);
  blocks[23] = new Block(390, 210);

  blocks[23] = new Block(30, 90);
  blocks[24] = new Block(90, 90);
  blocks[25] = new Block(150, 90);
  blocks[26] = new Block(210, 90);
  blocks[27] = new Block(270, 90);
  blocks[28] = new Block(330, 90);

  blocks[29] = new Block(390, 210);
  blocks[30] = new Block(390, 150);
  blocks[31] = new Block(390, 90);


  blocks[32] = new Block(510, 270);
  blocks[33] = new Block(510, 330);
  blocks[34] = new Block(510, 390);
  blocks[35] = new Block(510, 450);
  blocks[36] = new Block(510, 210);
  blocks[37] = new Block(510, 150);
  blocks[38] = new Block(510, 90);

  blocks[39] = new Block(570, 390);
  blocks[40] = new Block(30, 150);


  endBlock = new FinishBlock(finishLine[0], finishLine[1]);
}



void hardRoom() { // Hard Mode
  finishLine[0] = 300; //X
  finishLine[1] = 300; //Y

  while (i != 1) {
    coins[0] = new Coins(30, 450, random(0, 3));
    coins[1] = new Coins(510, 90, random(0, 3));
    coins[2] = new Coins(570, 450, random(0, 3));
    coins[3] = new Coins(330, 510, random(0, 3));
    coins[4] = new Coins(150, 90, random(0, 3));
    i++;
  }



  //Points boarder (Coins)
  blocks[0] = new Block(30, 30);
  blocks[1] = new Block(90, 30);
  blocks[2] = new Block(150, 30);

  blocks[3] = new Block(210, 30);
  blocks[4] = new Block(270, 30);
  blocks[5] = new Block(330, 30);
  blocks[6] = new Block(390, 30);
  blocks[7] = new Block(450, 30);
  blocks[8] = new Block(510, 30);
  blocks[9] = new Block(570, 30);

  blocks[10] = new Block(210, 90);
  blocks[11] = new Block(450, 90);

  blocks[12] = new Block(210, 150);
  blocks[13] = new Block(450, 150);

  blocks[14] = new Block(150, 150);
  blocks[15] = new Block(510, 150);

  blocks[16] = new Block(450, 510);
  blocks[17] = new Block(510, 510);
  blocks[18] = new Block(570, 510);

  blocks[19] = new Block(30, 510);
  blocks[20] = new Block(90, 510);
  blocks[21] = new Block(150, 510);
  blocks[22] = new Block(210, 510);

  //[30, 90, 150, 210, 270, 330, 390, 450, 510, 570]
  blocks[23] = new Block(150, 390);
  blocks[24] = new Block(150, 450);
  blocks[25] = new Block(90, 450);

  blocks[26] = new Block(510, 270);
  blocks[27] = new Block(510, 330);
  blocks[28] = new Block(510, 390);

  blocks[29] = new Block(30, 330);
  blocks[30] = new Block(150, 330);

  blocks[31] = new Block(270, 390);
  blocks[32] = new Block(390, 390);
  blocks[33] = new Block(270, 270);
  blocks[34] = new Block(390, 270);

  //The goal line
  endBlock = new FinishBlock(finishLine[0], finishLine[1]);
}


void masterRoom() { //MASTER MODE
  finishLine[0] = 540;
  finishLine[1] = 240;

  //[30, 90, 150, 210, 270, 330, 390, 450, 510, 570]
  while (i != 1) {
    coins[0] = new Coins(210, 30, random(0, 3));
    coins[1] = new Coins(30, 510, random(0, 3));
    coins[2] = new Coins(570, 150, random(0, 3));
    coins[3] = new Coins(570, 390, random(0, 3));
    coins[4] = new Coins(270, 270, random(0, 3));
    i++;
  }



  //Points boarder (Coins)
  blocks[0] = new Block(30, 30);
  blocks[1] = new Block(90, 30);
  blocks[2] = new Block(150, 30);

  blocks[3] = new Block(30, 90);
  blocks[4] = new Block(90, 90);
  blocks[5] = new Block(150, 90);

  blocks[6] = new Block(270, 90); //Same value as 7
  blocks[7] = new Block(270, 90);
  blocks[8] = new Block(330, 90);

  blocks[9] = new Block(450, 90);

  blocks[10] = new Block(450, 450);
  blocks[11] = new Block(450, 150);
  blocks[12] = new Block(450, 210);
  blocks[13] = new Block(450, 270);
  blocks[14] = new Block(450, 330);
  blocks[15] = new Block(450, 390);


  blocks[16] = new Block(30, 450);
  blocks[17] = new Block(90, 450);
  blocks[18] = new Block(150, 450);
  blocks[19] = new Block(150, 450);
  blocks[20] = new Block(270, 450);
  blocks[21] = new Block(330, 450);

  //[30, 90, 150, 210, 270, 330, 390, 450, 510, 570]
  blocks[22] = new Block(570, 450);

  blocks[23] = new Block(570, 210);

  blocks[24] = new Block(570, 90);

  blocks[25] = new Block(570, 330);


  blocks[26] = new Block(330, 330);
  blocks[27] = new Block(210, 210);
  blocks[28] = new Block(210, 330);
  blocks[29] = new Block(330, 210);

  blocks[30] = new Block(390, 270);
  blocks[31] = new Block(90, 270);

  blocks[32] = new Block(90, 210);
  blocks[33] = new Block(90, 330);

  //The goal line
  endBlock = new FinishBlock(finishLine[0], finishLine[1]);
}

void drawBoard() {
  fill(backgroundColor);
  rect(0, 0, width, height);
  for (int x = 0; x < width; x += width / 10) {
    for (int y = 0; y < height; y += height / 10) {
      stroke(0);
      strokeWeight(1.5);
      line(x, 0, x, height);
      stroke(110);
      strokeWeight(1.5);
      line(x + 1.5, 0, x + 1.5, height);

      stroke(0);
      strokeWeight(1.5);
      line(0, y, width, y);
      stroke(110);
      strokeWeight(1.5);
      line(0, y +1.5, width, y +1.5);
    }
  }
}


//The board itself. Is used for all levels
void board() {

  if (coins != null) {
    //coins display
    for (int i = 0; i < coins.length; i++) {
      coins[i].display();
    }
  }

  if (blocks != null) {
    //Block display
    for (int i = 0; i < blocks.length; i++) {
      blocks[i].display();
    }
  }

  endBlock.finishDisplay();

  stroke(51);
  fill(0);
  strokeWeight(2);
  rect(0, 0, 180, 60);
  fill(255, 0, 0);
  textSize(35);
  text(" Jewels: "+points, 0, 42);


  cubeDetector.displayDetector();
}





//TASK: FIX the character movement for both input and character position and its movement

//Moving correlates to Canvas size. Ex: If Canvas is 600x600, then the
//block moves 60. 500x500 is 50, etc.
void keyPressed() {
  if (canMove){
    if (keyCode == LEFT) {
      // moveWidth -= tileSize;
      playerCounter-= 1;
      counterRevise();
      player.turn();
      //println("left");
    } else if (keyCode == RIGHT) {
      // moveWidth += tileSize;
      playerCounter+= 1;
      counterRevise();
      player.turn();
      //println("right");
    } else if (keyCode == ' ') { //Space bar
      player.move();
      pressByBeat = 0;
      //println("space");
    }
  }
}

void counterRevise() {
  if (playerCounter<0) {
    playerCounter=3;
  } else {
    playerCounter = playerCounter%4;
  }
}

//---------------------------------------------------------LEVEL DESIGN-------------------------------------------------------------------



//*/-------------------------------PROBELM 3temporary for player ------------------------
PVector onCircle(PVector coords, float r, int deg) {
  double t = degToRad(deg);
  return new PVector((int)(r*Math.cos(t)+coords.x), (int)(r*Math.sin(t)+coords.y));
}
double degToRad(int deg) {//Size of the triangle in height
  return -deg*(Math.PI/180);
}
//Making the triangle of the player
PVector[] makeTriangle(PVector center, float radius, int deg) {
  PVector p1 = onCircle(center, radius, deg);
  PVector p2 = onCircle(center, radius, deg+120);
  PVector p3 = onCircle(center, radius, deg-120);
  //return {x1:p1.x, y1:p1.y, x2:p2.x, y2:p2.y, x3:p3.x, y3:p3.y} ---COMEBACK
  PVector[] result = new PVector[3];
  result[0] = p1;
  result[1] = p2;
  result[3] = p3;
  return result;
}



//1,1 is the bottom left tile
//Test for out of bounds
PVector tileAt(int x, int y) {
  //int tileMax = boardSize/tileSize;

  int tileX = x*tileSize;
  int tileY = y*tileSize;
  int xCoords = tileX-tileSize;
  int yCoords = boardSize-tileY;
  //return {x: xCoords, y: yCoords} --COMEBACK
  return new PVector(xCoords, yCoords);
}
//-----------------------------------PROBLEM 3---------------------------------------------

//In general
boolean boxCollided() {
  //when red box hits white box
  return !(x2 > 540 || x2 < 470);
}

//For the Player
boolean boxCollidedPlayer(){
  //When ALL red box hits white box
  return (!(x2 > 540 || x2 < 470) || !(x21 > 540 || x21 < 470) || !(x22 > 540 || x22 < 470) || !(x23 > 540 || x23 < 470) || !(x24 > 540 || x24 < 470) || !(x25 > 540 || x25 < 470));
}

boolean boxEndCycle(){
  //has it reach the end?
  return x2 > width;
}

//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES
//------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES------------------CLASSES

class Button { //NEW
  PVector pos;
  float size;
  color col;
  String caption;
  boolean visible;

  Button(float x, float y, float r, String txt, color c) {
    pos = new PVector(x, y);
    size = r;
    caption = txt;
    col = c;
    visible = true;
  }

  void show() {
    fill(col);
    strokeWeight(3);
    rect(pos.x, pos.y, size + 100, size - 40);
    fill(0);
    float fontSize = size * 0.25;
    textSize(fontSize);
    float tw = textWidth(caption);
    float tx = pos.x + tw/width + 25;// 85
    float ty = pos.y + 50;
    text(caption, tx, ty);
  }
}





















//PLAYER CLASS
class Player {
  PVector center;
  PImage currentImg;
  float x;
  float y;
  float prevX;
  float prevY;
  int xPos;
  int yPos;
  //height and width are based on pixels of the png
  int playerHeight = 82;
  int playerWidth = 50;
  int movingCounter;
  //if you what it to go 5 squares set it to 4
  int moveLimit = 4;
  boolean flip;
  boolean horizontal;
  float shiftY = (playerHeight);
  float shiftX = (playerWidth);
  int counter;

  Player(int startPosX, int startPosY) {
    //sets x and y to tile coords
    x = tileAt(startPosX, startPosY).x;
    y = tileAt(startPosX, startPosY).y;
    xPos = startPosX;
    yPos = startPosY;

    //sets center
    center = new PVector(x+tileSize/2, y+tileSize/2);
    prevX = x;
    prevY = y;
    //currentImg = playerAnimation[6];
    turn();
  }

  void display() {
    turn();
    image(currentImg, x-shiftX, y+shiftY);
  }

  void turn() {
    counter = playerCounter;
    //println(counter);
    if (counter == 0) { //down
      shiftY = (playerHeight + 22);
      shiftX = (playerWidth);
      currentImg = playerAnimation[0];
    } else if (counter == 1) { //left
      shiftY = (playerHeight + 22);
      shiftX = (playerWidth);
      currentImg = playerAnimation[9];
    } else if (counter == 2) { //up
      shiftY = (playerHeight + 22);
      shiftX = (playerWidth);
      currentImg = playerAnimation[3];
    } else if (counter == 3) { //right
      shiftY = (playerHeight + 20);
      shiftX = (playerWidth - 10);
      currentImg = playerAnimation[6];
    }
  }

  void move() {
    counter = playerCounter;
    
    
    
    
    
    
    
    
    //println(counter);
    prevX = x;
    prevY = y;
    //println(center);
    if (counter == 0) { //down
      y = tileAt(xPos, --yPos).y;
      if (collisionBlock(x, y) || round(y) == 420){
        y = tileAt(xPos, ++yPos).y;
      }
    } else if (counter == 1) { //left
      x = tileAt(--xPos, yPos).x;
      if (collisionBlock(x, y) || round(x) == 0){
        x = tileAt(++xPos, yPos).x;
      }
    } else if (counter == 2) { //up
      y = tileAt(xPos, ++yPos).y;
      if (collisionBlock(x, y) || round(y) == -180){
        y = tileAt(xPos, --yPos).y;
      }
    } else if (counter == 3) { //right
      x = tileAt(++xPos, yPos).x;
      if (collisionBlock(x, y) || round(x) == 660){
        x = tileAt(--xPos, yPos).x;
      }

    }

    //Collect coins
    //println("player: "+x);
    //println("player: "+y);
    for (var i = 0; i < coins.length; i++){
      if (coins[i].rpos == round(x - 30) && coins[i].rpos2 == round(y + 150)){
          //Coins gone
          //println("collision");
          //println("player: "+x);
          //println("player: "+y);
          //println(coins[i].rpos);
          //println(coins[i].rpos2);
          coins[i].rpos = 1;
          coins[i].rpos2 = 1;
          points++;
      }
    }
   moveWidth = x;
   moveHeight = y;
   //println("-------------");
   // println("Char X: "+x);
   // println("Char Y: "+y);
   // println("prevX: "+prevX);
   // println("prevY: "+prevY);
   // println("moveW: "+moveWidth);
   // println("moveH: "+moveHeight);
   // println("Finish[0]: "+(finishLine[0] + 60));
   // println("Finish[1]: "+(finishLine[1] - 120));
   // println("-------------");
    
  }
  
  boolean collisionBlock(float positionX, float positionY){
    //Detect blocks
    for (var i = 0; i < blocks.length; i++){
       if (blocks[i].rpos == round(positionX - 30) && blocks[i].rpos2 == round(positionY + 150)){
         return true;
       }
     }
    return false;
  }
  
  
}


//-------------------------------------------------------ENEMY CLASS-----------------------------------------------
class Enemy {
  PVector center;
  PImage imgLeft = guard[13];
  PImage imgRight = guard[14];
  PImage imgUp = guard[15];
  PImage imgDown = guard[12];
  boolean moveAllowed = true; //Allow the guard to move once every beat
  boolean moveLock = false; //false if they just started moving forward. True to move back
  
  PImage currentImg;
  float x;
  float y;
  float prevX;
  float prevY;
  int xPos;
  int yPos;
  //height and width are based on pixels of the png
  int enemyHeight = 89;
  int enemyWidth = 50;
  int movingCounter = 0;
  //if you what it to go 5 squares set it to 4
  int moveLimit = difficultyMoveLimit; //change into a variable
  boolean flip;
  boolean horizontal;
  
  float enemyGuardWidth;
  float enemyGuardHeight;

  Enemy(int startPosX, int startPosY, boolean faceLeft, boolean moveHorizonal) {
    //sets x and y to tile coords
    x = tileAt(startPosX, startPosY).x;
    y = tileAt(startPosX, startPosY).y;
    xPos = startPosX;
    yPos = startPosY;
    this.enemyGuardWidth = x;
    this.enemyGuardHeight = y;
    //sets center
    center = new PVector(x+tileSize/2, y+tileSize/2);
    prevX = x;
    prevY = y;
    horizontal = moveHorizonal;
    flip = faceLeft;
    //if left then set imgLeft else set to imgRight
    if (horizontal == true){
      currentImg = faceLeft?imgLeft:imgRight;
    }else{
      currentImg = faceLeft?imgUp:imgDown;
    }
    movingCounter = faceLeft?moveLimit:0;
  }

  void display() {
    //shift makes it so police is set in the right place
    float shiftY = (enemyHeight)-(tileSize);
    float shiftX = (enemyWidth)-(tileSize) + 3;
    image(currentImg, x-shiftX, y-shiftY);
    //if its horizontal, the counter meets conditions, and the box is collided
    x = tileAt(xPos, yPos).x;
    y = tileAt(xPos, yPos).y;
    this.enemyGuardWidth = x;
    this.enemyGuardHeight = y;
    //updates counter only when box collides
    if (boxCollided() && moveAllowed && moveLock == false) { //Testing
      movingCounter += 1;
      moveAllowed = false;
    }else if (boxCollided() && moveAllowed && moveLock == true){
      movingCounter -= 1;
      moveAllowed = false;
    }
    //Collision
    for (var i=0; i < enemies.length; i++){
       if (enemies[i].enemyGuardWidth == player.x - 60 && enemies[i].enemyGuardHeight == player.y + 120){
           level = 7;
       }
    }
  }

  void move() {
    //print(movingCounter);
    if (horizontal && !(movingCounter > moveLimit) && moveLock == false) {
      xPos++;
      currentImg = imgRight;
    } else if (horizontal && movingCounter != -1 && moveLock == true) {
      xPos--;
      currentImg = imgLeft;
    }else if (!horizontal && !(movingCounter>moveLimit) && moveLock == false) {
      yPos++;
      currentImg = imgUp;
    } else if (!horizontal && movingCounter != -1 && moveLock == true) {
      yPos--;
      currentImg = imgDown;
    }
    if (movingCounter == moveLimit){
      moveLock = true; //Lock set. Now move back to original position 
    }
    if (!boxEndCycle()){
      //println("true");
      moveAllowed = true;
    }
    if (movingCounter == 0){
        moveLock = false; 
    }
  }
}

//-----------------------------------------------------------------------------------------------------------------

//----------------------------------------------------COINS CLASS--------------------------------------------------
class Coins {
  int rpos;
  int rpos2;
  float random;
  Coins(int randomCoinX, int randomCoinY, float i) {
    this.rpos = randomCoinX;
    this.rpos2 = randomCoinY;
    this.random = i;
  }

  void display() {
    push();
    //fill("gold");
    image(diamonds[round(this.random)], this.rpos - 22, this.rpos2 - 20, 45, 43);
    //ellipse(this.rpos, this.rpos2, width / 20, height / 16); //Outer circle
    //ellipse(this.rpos, this.rpos2, width / 40, height / 25); //Inner circle
    pop();
  }
}
//-----------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------BLOCK CLASS-------------------------------------------------
class Block {
  int rpos;
  int rpos2;
  Block(int randomBlockX, int randomBlockY) {
    this.rpos = randomBlockX;
    this.rpos2 = randomBlockY;
  }

  void display() {
    push();
    fill(75);
    rect(this.rpos - 20, this.rpos2 - 20, width / 15, height / 15); //Outer circle
    pop();
  }
}
//-----------------------------------------------------------------------------------------------------------------



//---------------------------------------------------FINISHING BLOCK CLASS-----------------------------------------
class FinishBlock {
  int rpos;
  int rpos2;
  FinishBlock(int randomBlockX, int randomBlockY) {
    this.rpos = randomBlockX;
    this.rpos2 = randomBlockY;
  }


  void finishDisplay() {
    push();
    fill(20, 75, 200);
    rect(this.rpos + 10, this.rpos2 + 10, width / 15, height / 15); //Outer circle
    pop();
  }
}
//-----------------------------------------------------------------------------------------------------------------



//----------------------------------------------------MUSIC BEAT CLASS---------------------------------------------
class Cube { //The red cube
  void displayDetector() {
    drawBar();


    //If condition for now. Enemy collision
  }

  void drawBar() {
    fill(0);
    rect(0, 540, 600, 60); //Whole bar
    fill(pressByBeat);
    rect(470, 540, 75, 75); //Beat detector?
    // now see if distance between two is less than sum of two radius"
    
    if (!boxCollidedPlayer() && pressByBeat == 0) { //If you miss the beat
      backgroundColor-= 50;
      //println(backgroundColor);
      println("OOPS");
    } else if (backgroundColor <= 60) {
      level = 7;
    }
    
    if (pressByBeat == 0) {
      //println("Pressed");
      pressByBeat = 255;
    }
  }


  void displayMainMenu() { //Shows a Cop and a Thief Running
    //noStroke();
    //rect(xMainMenu, yMainMenu, rectWidthMainMenu, rectHeightMainMenu);


    textSize(20);
    fill(255); //white
    text("Now playing: 2+2=5 8-bit", xMainMenu + 50, 575);
    //rect(xMainMenu, yMainMenu, rectWidthMainMenu, rectHeightMainMenu);
    
    image(playerAnimation[6], xMainMenu, yMainMenu - 50);
    image(guard[14], xMainMenu - 100, yMainMenu - 50);
    
    if (xMainMenu > width + 100) {
      xMainMenu = -rectWidthMainMenu - 1000;
    }
    xMainMenu+=2; //Change when needed
  }




  void displayLevel1() { //Music:
    //drawBar();
    noStroke();
    fill(14, 144, 243); //blue
    rect(x2, y2, rectWidth, rectHeight);
    fill(255, 0, 0, 255); //red
    rect(x21, y2, rectWidth, rectHeight); //+ 100
    rect(x22, y2, rectWidth, rectHeight);
    rect(x23, y2, rectWidth, rectHeight);
    rect(x24, y2, rectWidth, rectHeight);
    rect(x25, y2, rectWidth, rectHeight); //+500

    
    
    
    if (x2 > width) {
      x2 = -rectWidth;
    }
    if (x21 > width) {
      x21 = -rectWidth;
    }
    if (x22 > width) {
      x22 = -rectWidth;
    }
    if (x23 > width) {
      x23 = -rectWidth;
    }
    if (x24 > width) {
      x24 = -rectWidth;
    }
    if (x25 > width) {
      x25 = -rectWidth;
    }

    x2+=4.55; //Change when needed
    x21+=4.55; //Change when needed
    x22+=4.55; //Change when needed
    x23+=4.55; //Change when needed
    x24+=4.55; //Change when needed
    x25+=4.55; //Change when needed
   
  }

  void displayLevel2() { //Music:
    //drawBar();
    noStroke();
    fill(14, 144, 243); //blue
    rect(x2, y2, rectWidth, rectHeight);
    fill(255, 0, 0, 255); //red
    rect(x21, y2, rectWidth, rectHeight); //+ 100
    rect(x22, y2, rectWidth, rectHeight);
    rect(x23, y2, rectWidth, rectHeight);
    rect(x24, y2, rectWidth, rectHeight);
    rect(x25, y2, rectWidth, rectHeight); //+500
    if (x2 > width) {
      x2 = -rectWidth;
    }
    if (x21 > width) {
      x21 = -rectWidth;
    }
    if (x22 > width) {
      x22 = -rectWidth;
    }
    if (x23 > width) {
      x23 = -rectWidth;
    }
    if (x24 > width) {
      x24 = -rectWidth;
    }
    if (x25 > width) {
      x25 = -rectWidth;
    }
    x2+=6.2; //Change when needed
    x21+=6.2; //Change when needed
    x22+=6.2; //Change when needed
    x23+=6.2; //Change when needed
    x24+=6.2; //Change when needed
    x25+=6.2; //Change when needed
    
    
  }

  void displayLevel3() { //Music:
    //drawBar();
    noStroke();
    fill(14, 144, 243); //blue
    rect(x2, y2, rectWidth, rectHeight);
    fill(255, 0, 0, 255); //red
    rect(x21, y2, rectWidth, rectHeight); //+ 100
    rect(x22, y2, rectWidth, rectHeight);
    rect(x23, y2, rectWidth, rectHeight);
    rect(x24, y2, rectWidth, rectHeight);
    rect(x25, y2, rectWidth, rectHeight); //+500
    if (x2 > width) {
      x2 = -rectWidth;
    }
    if (x21 > width) {
      x21 = -rectWidth;
    }
    if (x22 > width) {
      x22 = -rectWidth;
    }
    if (x23 > width) {
      x23 = -rectWidth;
    }
    if (x24 > width) {
      x24 = -rectWidth;
    }
    if (x25 > width) {
      x25 = -rectWidth;
    }
    x2+=6.95; //Change when needed (9.9)
    x21+=6.95; //Change when needed
    x22+=6.95; //Change when needed
    x23+=6.95; //Change when needed
    x24+=6.95; //Change when needed
    x25+=6.95; //Change when needed
    
    
    
    
    
    
  }

  void displayLevel4() { //Music: Super Mario Galaxy 2
    //drawBar();
    noStroke();
    fill(14, 144, 243); //blue
    rect(x2, y2, rectWidth, rectHeight);
    fill(255, 0, 0, 255); //red
    rect(x21, y2, rectWidth, rectHeight); //+ 100
    rect(x22, y2, rectWidth, rectHeight);
    rect(x23, y2, rectWidth, rectHeight);
    rect(x24, y2, rectWidth, rectHeight);
    rect(x25, y2, rectWidth, rectHeight); //+500
    if (x2 > width) {
      x2 = -rectWidth;
    }
    if (x21 > width) {
      x21 = -rectWidth;
    }
    if (x22 > width) {
      x22 = -rectWidth;
    }
    if (x23 > width) {
      x23 = -rectWidth;
    }
    if (x24 > width) {
      x24 = -rectWidth;
    }
    if (x25 > width) {
      x25 = -rectWidth;
    }
    x2+=6.99; //Change when needed (9.9)
    x21+=6.99; //Change when needed
    x22+=6.99; //Change when needed
    x23+=6.99; //Change when needed
    x24+=6.99; //Change when needed
    x25+=6.99; //Change when needed
    
  }
}
//-----------------------------------------------------------------------------------------------------------------
