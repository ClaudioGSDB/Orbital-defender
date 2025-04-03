class Meteor {
  PVector position;
  PVector velocity;
  int size; // 1=small, 2=medium, 3=large
  float rotation;
  float rotationSpeed;
  color meteorColor;
  float[] vertexDistances; // For procedural shape
  
  // Constructor
  Meteor(float x, float y, int meteorSize);
  
  // Generate the meteor's procedural shape
  void generateShape();
  
  // Update meteor position
  void update();
  
  // Display meteor
  void display();
  
  // Check if meteor collides with planet
  boolean collidesWithPlanet();
  
  // Check if meteor is hit by projectile
  boolean isHitByProjectile(Projectile p);
  
  // Get meteor radius for collision detection
  float getRadius();
  
  // Check if meteor is off screen
  boolean isOffscreen();
  
  // Get damage this meteor does to planet
  int getDamage();
  
  // Get meteor size for scoring
  int getSize();
}
