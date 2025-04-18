class Player {
  PVector position;
  PVector center;
  float angle;
  float orbitRadius;
  float orbitSpeed;
  
  private long lastShotTime = 0;
  private int shotCooldown = 200; // milliseconds between shots
  
  Player(float centerX, float centerY, float radius) {
    center = new PVector(centerX, centerY);
    orbitRadius = radius;
    angle = 0;
    orbitSpeed = 0.035;
    
    updatePosition();
  }
  
  void update() {
    if (keys[LEFT] || keys['A']) {
      angle -= orbitSpeed;
    }
    if (keys[RIGHT] || keys['D']) {
      angle += orbitSpeed;
    }
    
    if (angle < 0) angle += TWO_PI;
    if (angle > TWO_PI) angle -= TWO_PI;
    
    updatePosition();
    
    if (leftMousePressed) {
      fire();
    }
  }
  
  void updatePosition() {
    position = new PVector(
      center.x + cos(angle) * orbitRadius,
      center.y + sin(angle) * orbitRadius
    );
  }
  
  void fire() {
    long currentTime = millis();
    if (currentTime - lastShotTime < shotCooldown) {
      return;
    }
    lastShotTime = currentTime;
    
    PVector target = new PVector(mouseX, mouseY);
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    
    Projectile projectile = new Projectile(
      position.x, position.y,
      direction.x * 8, direction.y * 8
    );
    
    projectiles.add(projectile);
    
    // Play sound
    if (laserSound != null) {
      laserSound.play();
    }
  }
  
  void display() {
    pushMatrix();
    translate(position.x, position.y);
    
    float targetAngle = atan2(mouseY - position.y, mouseX - position.x);
    rotate(targetAngle + HALF_PI);
    
    imageMode(CENTER);
    image(shipImage, 0, 0);
    
    if (keys[LEFT] || keys['A'] || keys[RIGHT] || keys['D']) {
      drawThruster();
    }
    
    popMatrix();
  }
  
  void drawThruster() {
    noStroke();
    
    fill(255, 100, 0, 200);
    beginShape();
    vertex(0, 15);
    vertex(-5, 25 + random(5));
    vertex(0, 30 + random(10));
    vertex(5, 25 + random(5));
    endShape(CLOSE);
    
    fill(255, 255, 0, 200);
    beginShape();
    vertex(0, 15);
    vertex(-3, 20 + random(5));
    vertex(0, 25 + random(5));
    vertex(3, 20 + random(5));
    endShape(CLOSE);
  }
}
