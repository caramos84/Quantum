int maxDepth = 0;
float baseAngle = PI / 4;
float randomness = 0.7;

void setup() {
  size(600, 600);
  background(0);
  stroke(255);
  frameRate(1);
}

void draw() {
  background(10, 10, 20);  // fondo azul oscuro
  translate(width/2, height);
  drawCoral(150, 0);
  
  maxDepth++;
  if (maxDepth > 12) {
    noLoop();  // Detén si quieres un efecto de crecimiento
  }
}

void drawCoral(float len, int depth) {
  if (depth >= maxDepth || len < 2) return;

  // Colores orgánicos según profundidad
  stroke(lerpColor(color(255, 100, 100), color(100, 255, 255), depth / float(maxDepth)));
  strokeWeight(map(depth, 0, maxDepth, 2, 0.2));
  line(0, 0, 0, -len);
  translate(0, -len);
  
  int branches = int(random(2, 4));  // entre 2 y 3 ramas
  for (int i = 0; i < branches; i++) {
    pushMatrix();
    float angle = baseAngle * (random(-randomness, randomness));
    rotate(angle);
    drawCoral(len * random(0.6, 0.8), depth + 1);
    popMatrix();
  }
}
