// Import the sound library for Processing
import processing.sound.*;

// Game states
final int STATE_MENU = 0;
final int STATE_GAME = 1; 
final int STATE_GAME_OVER = 2;

// Current game state
int gameState = STATE_MENU;

// Difficulty levels
final int DIFFICULTY_EASY = 0;
final int DIFFICULTY_HARD = 1;
int currentDifficulty = DIFFICULTY_EASY;

// Game elements
Player player;
ArrayList<Meteor> meteors;
ArrayList<Projectile> projectiles;

// Game variables
int score = 0;
int highScore = 0;
int planetHealth = 100;
PVector planetCenter;
float planetRadius = 80;

// Asset variables
PImage planetImage, shipImage, projectileImage, backgroundImage;
SoundFile backgroundMusic, laserSound, explosionSound, buttonSound;

// Input tracking
boolean[] keys = new boolean[256];
boolean leftMousePressed = false;

// UI elements
ArrayList<Button> menuButtons = new ArrayList<Button>();

// Function prototypes
void setup();
void draw();
void keyPressed();
void keyReleased();
void mousePressed();
void mouseReleased();
void initializeGame(int difficulty);
void updateGame();
void displayGame();
void drawMainMenu();
void drawGameOver();
void spawnMeteor();
void checkCollisions();
float getSpawnRate();
void drawHUD();
void initializeMenu();

// Button class
class Button {
  float x, y, w, h;
  String label;
  Runnable action;
  
  // Constructor
  Button(float xPos, float yPos, float width, float height, String buttonLabel, Runnable buttonAction);
  
  // Display the button
  void display();
  
  // Check if mouse is over button
  boolean isMouseOver();
  
  // Handle button click
  void click();
}

// Runnable interface for button actions
interface Runnable {
  void run();
}
