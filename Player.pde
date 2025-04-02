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
    orbitSpeed = 0.05;
    
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
      direction.x * 5, direction.y * 5  // Speed of 5 pixels per frame
    );
    
    // Add to game
    projectiles.add(projectile);
    
    // Play sound
    laserSound.play();
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
    
    popMatrix();
  }
  
  // Variables for shot timing
  private long lastShotTime = 0;
  private int shotCooldown = 300; // milliseconds between shots
}
