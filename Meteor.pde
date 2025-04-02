class Meteor {
  PVector position;
  PVector velocity;
  float size;
  float rotation;
  float rotationSpeed;
  boolean isDestroyed;
  
  // Constructor
  Meteor(float x, float y, float meteorSize){};
  
  // Update meteor position
  void update();
  
  // Display meteor
  void display();
  
  // Check if meteor collides with planet
  boolean collidesWithPlanet();
  
  // Check if meteor collides with player
  boolean collidesWithPlayer();
  
  // Check if meteor is hit by projectile
  boolean isHitByProjectile(Projectile p);
  
  // Check if meteor is off screen
  boolean isOffscreen();
}
