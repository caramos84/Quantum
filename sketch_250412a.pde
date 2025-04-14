ArrayList<Node> nodes;
int maxNodes = 400;
int nextId = 0;

void setup() {
  size(800, 800);
  background(0);
  frameRate(30);
  nodes = new ArrayList<Node>();
  
  nodes.add(new Node(width/2, height/2, nextId++));
}

void draw() {
  background(0, 25); // Persistencia visual
  
  // Crecimiento de red
  if (nodes.size() < maxNodes) {
    Node parent = nodes.get(int(random(nodes.size())));
    float angle = random(TWO_PI);
    float distance = random(40, 90);
    float newX = parent.x + cos(angle) * distance;
    float newY = parent.y + sin(angle) * distance;
    
    Node newNode = new Node(newX, newY, nextId++);
    newNode.connectTo(parent);
    nodes.add(newNode);
  }
  
  // Visualización
  for (Node n : nodes) {
    n.display();
  }
}

class Node {
  float x, y;
  int id;
  ArrayList<Node> connections;

  Node(float x, float y, int id) {
    this.x = x;
    this.y = y;
    this.id = id;
    connections = new ArrayList<Node>();
  }
  
  void connectTo(Node other) {
    connections.add(other);
  }

  void display() {
    // Pulsación suave
    float pulse = 3 + sin(radians(frameCount + id * 7)) * 3;
    
    // Dibujar conexiones
    stroke(lerpColor(color(200, 100, 255), color(100, 255, 200), id / float(maxNodes)));
    strokeWeight(0.8 + sin(radians(frameCount * 2 + id * 10)) * 0.5);
    for (Node other : connections) {
      line(x, y, other.x, other.y);
    }
    
    // Dibujar nodo
    noStroke();
    fill(255);
    ellipse(x, y, pulse, pulse);
  }
}
