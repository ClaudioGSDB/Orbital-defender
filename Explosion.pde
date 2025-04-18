class Explosion {
  PVector position;
  float size;
  float lifespan;
  float maxLifespan;
  color explosionColor;
  
  Explosion(float x, float y, float explosionSize) {
    position = new PVector(x, y);
    size = explosionSize;
    maxLifespan = 30;
    lifespan = maxLifespan;
    
    // Random hue variation for different explosions
    explosionColor = color(
      255,                  // Red
      200 + random(-50, 50), // Orange/yellow variation
      50 + random(-50, 50)   // Some yellow/red variation
    );
  }
  
  void update() {
    lifespan--;
  }
  
  boolean isDead() {
    return lifespan <= 0;
  }
  
  void display() {
    float progress = lifespan / maxLifespan;
    float alpha = 255 * progress;
    float currentSize = size * (1 - progress * 0.3); // Starts at size, grows slightly
    
    pushMatrix();
    translate(position.x, position.y);
    
    // Outer blast wave
    noStroke();
    fill(red(explosionColor), green(explosionColor), blue(explosionColor), alpha * 0.7);
    ellipse(0, 0, currentSize * 2, currentSize * 2);
    
    // Inner explosion
    fill(255, 255, 200, alpha);
    ellipse(0, 0, currentSize * progress, currentSize * progress);
    
    // Spark/debris particles
    stroke(255, 255, 200, alpha);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float angle = TWO_PI * i / 8 + random(-0.2, 0.2);
      float particleDistance = currentSize * (0.7 + (1 - progress) * 0.5);
      line(0, 0, 
           cos(angle) * particleDistance, 
           sin(angle) * particleDistance);
    }
    
    popMatrix();
  }
}
