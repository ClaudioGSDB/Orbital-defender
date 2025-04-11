import processing.sound.*;

final int STATE_MENU = 0;
final int STATE_GAME = 1;
final int STATE_GAME_OVER = 2;

int gameState = STATE_MENU;

final int DIFFICULTY_EASY = 0;
final int DIFFICULTY_HARD = 1;
int currentDifficulty = DIFFICULTY_EASY;

Player player;
ArrayList<Meteor> meteors;
ArrayList<Projectile> projectiles;

int score = 0;
int highScore = 0;
int planetHealth = 100;
PVector planetCenter;
float planetRadius = 80;

PImage planetImage, planetImageHard, shipImage, projectileImage, backgroundImage;
SoundFile backgroundMusic, laserSound, explosionSound, buttonSound;

boolean[] keys = new boolean[256];
boolean leftMousePressed = false;

ArrayList<Button> menuButtons = new ArrayList<Button>();
boolean gameInitialized = false;

void setup() {
  size(1024, 768);
  frameRate(60);
  smooth();

  planetImage = loadImage("data/images/planet.png");
  planetImageHard = loadImage("data/images/planet-hard.png");
  shipImage = loadImage("data/images/ship.png");
  projectileImage = loadImage("data/images/projectile.png");
  backgroundImage = loadImage("data/images/background.png");

  /* Uncomment if you have sound files
   backgroundMusic = new SoundFile(this, "data/sounds/background_music.mp3");
   laserSound = new SoundFile(this, "data/sounds/laser_shot.mp3");
   explosionSound = new SoundFile(this, "data/sounds/explosion.mp3");
   buttonSound = new SoundFile(this, "data/sounds/button_click.mp3");
   */

  planetCenter = new PVector(width/2, height/2);
  meteors = new ArrayList<Meteor>();
  projectiles = new ArrayList<Projectile>();

  initializeMenu();
}

void draw() {
  switch(gameState) {
  case STATE_MENU:
    drawMainMenu();
    break;
  case STATE_GAME:
    if (!gameInitialized) {
      initializeGame(currentDifficulty);
      gameInitialized = true;
    }
    updateGame();
    displayGame();
    break;
  case STATE_GAME_OVER:
    drawGameOver();
    break;
  }
}

void initializeMenu() {
  menuButtons.clear();

  menuButtons.add(new Button(width/2, height/2 - 60, 200, 50, "Start Game - Easy", new Runnable() {
    public void run() {
      currentDifficulty = DIFFICULTY_EASY;
      gameState = STATE_GAME;
      gameInitialized = false;
    }
  }
  ));

  menuButtons.add(new Button(width/2, height/2 + 10, 200, 50, "Start Game - Hard", new Runnable() {
    public void run() {
      currentDifficulty = DIFFICULTY_HARD;
      gameState = STATE_GAME;
      gameInitialized = false;
    }
  }
  ));

  menuButtons.add(new Button(width/2, height/2 + 80, 200, 50, "Quit", new Runnable() {
    public void run() {
      exit();
    }
  }
  ));
}

void initializeGame(int difficulty) {
  score = 0;
  planetHealth = 100;

  meteors.clear();
  projectiles.clear();

  player = new Player(width/2, height/2, 120);

  /* Uncomment if you have sound files
   if (backgroundMusic != null) {
   backgroundMusic.loop();
   }
   */
}

void updateGame() {
  player.update();

  for (int i = projectiles.size() - 1; i >= 0; i--) {
    Projectile projectile = projectiles.get(i);
    projectile.update();

    if (projectile.isOffscreen()) {
      projectiles.remove(i);
    }
  }

  for (int i = meteors.size() - 1; i >= 0; i--) {
    Meteor meteor = meteors.get(i);
    meteor.update();

    if (meteor.isOffscreen()) {
      meteors.remove(i);
      continue;
    }

    if (meteor.collidesWithPlanet()) {
      planetHealth -= meteor.getDamage();

      /* Uncomment if you have sound files
       if (explosionSound != null) {
       explosionSound.play();
       }
       */

      meteors.remove(i);

      if (planetHealth <= 0) {
        gameState = STATE_GAME_OVER;
        if (score > highScore) {
          highScore = score;
        }
      }

      continue;
    }

    for (int j = projectiles.size() - 1; j >= 0; j--) {
      Projectile projectile = projectiles.get(j);
      if (meteor.isHitByProjectile(projectile)) {
        score += 10 * meteor.getSize();

        /* Uncomment if you have sound files
         if (explosionSound != null) {
         explosionSound.play();
         }
         */

        projectiles.remove(j);
        meteors.remove(i);
        break;
      }
    }
  }

  if (random(1) < getSpawnRate()) {
    spawnMeteor();
  }
}

float getSpawnRate() {
  float baseRate = (currentDifficulty == DIFFICULTY_EASY) ? 0.02 : 0.05;
  float maxRate = (currentDifficulty == DIFFICULTY_EASY) ? 0.06 : 0.12;
  float scoreContribution = min(maxRate - baseRate, score / 1000.0);
  return baseRate + scoreContribution;
}

void spawnMeteor() {
  float angle = random(TWO_PI);
  float spawnDistance = sqrt(pow(width/2, 2) + pow(height/2, 2)) * 0.9;
  PVector position = new PVector(
    width/2 + cos(angle) * spawnDistance,
    height/2 + sin(angle) * spawnDistance
    );

  int size = floor(random(1, 4));

  if (currentDifficulty == DIFFICULTY_HARD && random(1) < 0.4) {
    size = floor(random(2, 4));
  }

  meteors.add(new Meteor(position.x, position.y, size));
}

void displayGame() {
  background(0);
  imageMode(CENTER);
  image(backgroundImage, width/2, height/2, width, height);

  if (currentDifficulty == DIFFICULTY_EASY) {
    image(planetImage, planetCenter.x, planetCenter.y);
  }
  else{
    image(planetImageHard, planetCenter.x, planetCenter.y);
  }



  for (Meteor meteor : meteors) {
    meteor.display();
  }

  for (Projectile projectile : projectiles) {
    projectile.display();
  }

  player.display();

  drawHUD();
}

void drawHUD() {
  fill(255);
  textAlign(LEFT, TOP);
  textSize(20);
  text("Score: " + score, 20, 20);

  text("Planet Health: " + planetHealth + "%", 20, 50);

  float barWidth = 150;
  noFill();
  stroke(255);
  rect(20, 80, barWidth, 15);

  fill(map(planetHealth, 0, 100, 255, 0), map(planetHealth, 0, 100, 0, 255), 0);
  noStroke();
  rect(20, 80, barWidth * (planetHealth/100.0), 15);
}

void drawMainMenu() {
  imageMode(CENTER);
  image(backgroundImage, width/2, height/2, width, height);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("ORBITAL DEFENDER", width/2, height/4);

  for (Button button : menuButtons) {
    button.display();
  }

  textSize(20);
  text("High Score: " + highScore, width/2, height - 50);
}

void drawGameOver() {
  fill(0, 180);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("GAME OVER", width/2, height/3);

  textSize(30);
  text("Score: " + score, width/2, height/2);

  if (score == highScore) {
    text("NEW HIGH SCORE!", width/2, height/2 + 50);
  } else {
    text("High Score: " + highScore, width/2, height/2 + 50);
  }

  textSize(20);
  text("Press SPACE to return to menu", width/2, height/2 + 120);
}

void keyPressed() {
  keys[keyCode] = true;

  if (keyCode == ' ' && gameState == STATE_GAME_OVER) {
    gameState = STATE_MENU;
  }
}

void keyReleased() {
  keys[keyCode] = false;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    leftMousePressed = true;

    if (gameState == STATE_MENU) {
      for (Button button : menuButtons) {
        if (button.isMouseOver()) {
          button.click();
          /* Uncomment if you have sound files
           if (buttonSound != null) {
           buttonSound.play();
           }
           */
        }
      }
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    leftMousePressed = false;
  }
}

class Button {
  float x, y, w, h;
  String label;
  Runnable action;

  Button(float xPos, float yPos, float width, float height, String buttonLabel, Runnable buttonAction) {
    x = xPos - width/2;
    y = yPos - height/2;
    w = width;
    h = height;
    label = buttonLabel;
    action = buttonAction;
  }

  void display() {
    boolean hover = isMouseOver();

    if (hover) {
      fill(100, 100, 255);
    } else {
      fill(70, 70, 200);
    }
    stroke(255);
    strokeWeight(2);
    rect(x, y, w, h, 10);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(label, x + w/2, y + h/2);
  }

  boolean isMouseOver() {
    return (mouseX >= x && mouseX <= x + w &&
      mouseY >= y && mouseY <= y + h);
  }

  void click() {
    action.run();
  }
}

interface Runnable {
  void run();
}
