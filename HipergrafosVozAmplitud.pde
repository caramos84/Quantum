import processing.sound.*;

ArrayList<Node> nodes;
int maxNodes = 400;
int nextId = 0;

AudioIn mic;
Amplitude amp;
float currentVolume = 0;

void setup() {
  size(600, 600);
  background(0);
  frameRate(30);

  nodes = new ArrayList<Node>();
  nodes.add(new Node(width / 2, height - 30, nextId++));  // Nodo raíz desde abajo

  mic = new AudioIn(this, 0);
  mic.start();

  amp = new Amplitude(this);
  amp.input(mic);
}

void draw() {
  background(0, 25); // Persistencia visual

  currentVolume = amp.analyze();  // Volumen actual del micrófono

  // Crecimiento si el volumen supera cierto umbral
  if (currentVolume > 0.02 && nodes.size() < maxNodes) {
    Node parent = nodes.get(int(random(nodes.size())));

    float angle = random(-PI / 2.5, PI / 2.5);  // Inclinación leve izquierda/derecha
    float distance = random(60, 90);

    float newX = parent.x + sin(angle) * distance * 0.5;  // Ramificación lateral
    float newY = parent.y - abs(cos(angle)) * distance;   // Siempre hacia arriba

    Node newNode = new Node(newX, newY, nextId++);
    newNode.connectTo(parent);
    nodes.add(newNode);
  }

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
    // Normalizar volumen para tamaño y brillo
    float vol = constrain(currentVolume * 20.0, 0.2, 2.5);
    float brightness = map(currentVolume, 0, 0.1, 50, 255);

    // Conexiones
    stroke(lerpColor(color(200, 100, 255), color(100, 255, 200), id / float(maxNodes)));
    strokeWeight(0.5 + vol * 0.5);
    for (Node other : connections) {
      line(x, y, other.x, other.y);
    }

    // Nodo pulsante
    noStroke();
    fill(brightness);
    ellipse(x, y, 4 * vol, 4 * vol);
  }
}
