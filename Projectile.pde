class Projectile {
  PVector position;
  PVector velocity;
  float rotation;
  float tailLength = 15; // Length of the projectile trail
  
  // Constructor
  Projectile(float x, float y, float vx, float vy);
  
  // Update projectile position
  void update();
  
  // Display projectile
  void display();
  
  // Draw a glowing trail behind the projectile
  void drawTrail();
  
  // Check if projectile is off screen
  boolean isOffscreen();
}
