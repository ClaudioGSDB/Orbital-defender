class Meteor {
  PVector position;
  PVector velocity;
  int size;
  float rotation;
  float rotationSpeed;
  color meteorColor;
  float[] vertexDistances;

  Meteor(float x, float y, int meteorSize) {
    position = new PVector(x, y);
    size = meteorSize;

    PVector center = new PVector(width/2, height/2);
    velocity = PVector.sub(center, position);

    float baseSpeed = (4 - size) * 0.5;
    float difficultyMultiplier = (currentDifficulty == DIFFICULTY_EASY) ? 0.5 : 1;

    velocity.normalize();
    velocity.mult(baseSpeed * difficultyMultiplier);

    rotation = random(TWO_PI);
    rotationSpeed = random(0.01, 0.05);

    meteorColor = color(
      150 + random(-30, 30),
      80 + random(-30, 30),
      80 + random(-30, 30)
      );

    generateShape();
  }

  void generateShape() {
    int vertexCount = 8;
    vertexDistances = new float[vertexCount];

    float baseRadius = size * 12;

    for (int i = 0; i < vertexCount; i++) {
      vertexDistances[i] = baseRadius * (0.8 + random(0.4));
    }
  }

  void update() {
    position.add(velocity);
    rotation += rotationSpeed;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);

    fill(meteorColor);
    stroke(red(meteorColor) + 40, green(meteorColor) + 40, blue(meteorColor) + 40);
    strokeWeight(2);

    beginShape();
    for (int i = 0; i < vertexDistances.length; i++) {
      float angle = TWO_PI * i / vertexDistances.length;
      float x = cos(angle) * vertexDistances[i];
      float y = sin(angle) * vertexDistances[i];
      vertex(x, y);
    }
    endShape(CLOSE);

    popMatrix();
  }

  boolean collidesWithPlanet() {
    float distance = PVector.dist(position, planetCenter);
    return distance < (planetRadius + getRadius());
  }

  boolean isHitByProjectile(Projectile p) {
    float distance = PVector.dist(position, p.position);
    return distance < getRadius();
  }

  float getRadius() {
    float sum = 0;
    for (float dist : vertexDistances) {
      sum += dist;
    }
    return sum / vertexDistances.length;
  }

  boolean isOffscreen() {
    float radius = getRadius();
    float buffer = 50;

    return (position.x + radius + buffer < 0 ||
      position.x - radius - buffer > width ||
      position.y + radius + buffer < 0 ||
      position.y - radius - buffer > height);
  }

  int getDamage() {
    return size * 10;
  }

  int getSize() {
    return size;
  }
}
