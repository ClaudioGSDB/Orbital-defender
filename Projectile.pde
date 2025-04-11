class Projectile {
  PVector position;
  PVector velocity;
  float rotation;
  float tailLength = 30; // Length of the projectile trail
  
  // Constructor
  Projectile(float x, float y, float vx, float vy) {
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    
    // Calculate rotation based on velocity direction
    rotation = atan2(vy, vx);
  }
  
  // Update projectile position
  void update() {
    position.add(velocity);
  }
  
  // Display projectile
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    // Draw projectile using the image
    imageMode(CENTER);
    image(projectileImage, 0, 0);
    
    // Draw trail effect
    drawTrail();
    
    popMatrix();
  }
  
  // Draw a glowing trail behind the projectile
  void drawTrail() {
    // Glow trail
    noStroke();
    
    // Outer trail (blue-white gradient)
    beginShape(QUAD_STRIP);
    for (int i = 0; i <= 5; i++) {
      float alpha = map(i, 0, 5, 200, 0);
      float width = map(i, 0, 5, 6, 1);
      float length = map(i, 0, 5, 0, -tailLength);
      
      fill(100, 200, 255, alpha);
      vertex(length, width/2);
      vertex(length, -width/2);
    }
    endShape();
    
    // Inner trail (brighter)
    beginShape(QUAD_STRIP);
    for (int i = 0; i <= 5; i++) {
      float alpha = map(i, 0, 5, 255, 0);
      float width = map(i, 0, 5, 3, 0.5);
      float length = map(i, 0, 5, 0, -tailLength * 0.8);
      
      fill(200, 240, 255, alpha);
      vertex(length, width/2);
      vertex(length, -width/2);
    }
    endShape();
  }
  
  // Check if projectile is off screen
  boolean isOffscreen() {
    return (position.x < 0 || 
            position.x > width || 
            position.y < 0 || 
            position.y > height);
  }
}
