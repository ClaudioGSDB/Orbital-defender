class Player {
  PVector position;
  PVector center;
  float angle;
  float orbitRadius;
  float orbitSpeed;
  
  // Constructor
  Player(float centerX, float centerY, float radius) {
    center = new PVector(centerX, centerY);
    orbitRadius = radius;
    angle = 0;
    orbitSpeed = 0.035;
    
    // Calculate initial position
    updatePosition();
  }
  
  // Update player position based on input
  void update() {
    // Movement with A/D or Left/Right arrows
    if (keys[LEFT] || keys['A']) {
      angle -= orbitSpeed;
    }
    if (keys[RIGHT] || keys['D']) {
      angle += orbitSpeed;
    }
    
    // Keep angle within 0-TWO_PI range
    if (angle < 0) angle += TWO_PI;
    if (angle > TWO_PI) angle -= TWO_PI;
    
    // Update position
    updatePosition();
    
    // Handle shooting
    if (leftMousePressed) {
      fire();
    }
  }
  
  // Calculate orbital position
  void updatePosition() {
    position = new PVector(
      center.x + cos(angle) * orbitRadius,
      center.y + sin(angle) * orbitRadius
    );
  }
  
  // Fire projectile
  void fire() {
    // Limit fire rate by checking time since last shot
    long currentTime = millis();
    if (currentTime - lastShotTime < shotCooldown) {
      return;
    }
    lastShotTime = currentTime;
    
    // Calculate direction toward mouse
    PVector target = new PVector(mouseX, mouseY);
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    
    // Create new projectile
    Projectile projectile = new Projectile(
      position.x, position.y,
      direction.x * 8, direction.y * 8  // Speed of 8 pixels per frame
    );
    
    // Add to game
    projectiles.add(projectile);
    
    // Play sound
    //if (laserSound != null) {
    //  laserSound.play();
    //}
  }
  
  // Display the player
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    
    // Calculate rotation to face mouse
    float targetAngle = atan2(mouseY - position.y, mouseX - position.x);
    rotate(targetAngle + HALF_PI); // Adjust for image orientation
    
    // Draw ship
    imageMode(CENTER);
    image(shipImage, 0, 0);
    
    // Add thruster effect when moving
    if (keys[LEFT] || keys['A'] || keys[RIGHT] || keys['D']) {
      drawThruster();
    }
    
    popMatrix();
  }
  
  // Draw thruster effect
  void drawThruster() {
    // Draw at back of ship (assuming ship faces upward by default)
    noStroke();
    
    // Main thrust
    fill(255, 100, 0, 200);
    beginShape();
    vertex(0, 15);
    vertex(-5, 25 + random(5));
    vertex(0, 30 + random(10));
    vertex(5, 25 + random(5));
    endShape(CLOSE);
    
    // Inner thrust
    fill(255, 255, 0, 200);
    beginShape();
    vertex(0, 15);
    vertex(-3, 20 + random(5));
    vertex(0, 25 + random(5));
    vertex(3, 20 + random(5));
    endShape(CLOSE);
  }
  
  // Variables for shot timing
  private long lastShotTime = 0;
  private int shotCooldown = 200; // milliseconds between shots
}
