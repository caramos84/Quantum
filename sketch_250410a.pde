int maxDepth = 0;  // nivel de recursión que irá aumentando
float angle;

void setup() {
  size(600, 600);
  frameRate(3);
  stroke(255);
  background(0);
}

void draw() {
  background(0);
  translate(width / 2, height);
  angle = radians(10);
  drawBranch(180, 0);
  maxDepth++;
  if (maxDepth > 10) {
    noLoop();  // Detiene la animación cuando ya está bastante ramificado
  }
}

void drawBranch(float len, int depth) {
  if (depth >= maxDepth) return;
  
  stroke(lerpColor(color(255, 200, 100), color(0, 255, 255), depth / float(maxDepth)));
  line(0, 0, 0, -len);
  translate(0, -len);
  
  pushMatrix();
  rotate(angle);
  drawBranch(len * 0.67, depth + 1);
  popMatrix();
  
  pushMatrix();
  rotate(-angle);
  drawBranch(len * 0.67, depth + 1);
  popMatrix();
}
