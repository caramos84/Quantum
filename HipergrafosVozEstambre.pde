import processing.sound.*;

ArrayList<Node> nodes;
ArrayList<Node> activeNodes;
int maxNodes = 600;
int nextId = 0;

AudioIn mic;
Amplitude amp;
float currentVolume = 0;
float previousVolume = 0;

boolean mutacionActiva = false;
boolean bloqueado = false;
int mutacionTimer = 0;
int mutacionDuracion = 200;

void setup() {
  size(600, 600);
  background(0);
  frameRate(30);

  nodes = new ArrayList<Node>();
  activeNodes = new ArrayList<Node>();

  Node root = new Node(width / 2, height - 30, nextId++);
  nodes.add(root);
  activeNodes.add(root);

  mic = new AudioIn(this, 0);
  mic.start();

  amp = new Amplitude(this);
  amp.input(mic);
}

void draw() {
  background(0, 25);

  previousVolume = currentVolume;
  currentVolume = amp.analyze();

  if (!mutacionActiva && currentVolume > 0.07 && previousVolume > 0.06) {
    mutacionActiva = true;
    bloqueado = false;
    mutacionTimer = frameCount;
  }

  if (mutacionActiva && currentVolume > 0.2 && previousVolume < 0.1) {
    bloqueado = true;
  }

  if (mutacionActiva && frameCount - mutacionTimer > mutacionDuracion) {
    mutacionActiva = false;
  }

  if (!bloqueado && activeNodes.size() > 0 && nodes.size() < maxNodes && currentVolume > 0.02) {
    Node parent = activeNodes.get(int(random(activeNodes.size())));

    float angle = random(-PI / 4, PI / 4); // controlado
    float distance = mutacionActiva ? random(40, 60) : random(30, 50);

    float newX = parent.x + sin(angle) * distance;
    float newY = parent.y - abs(cos(angle)) * distance;

    Node newNode = new Node(newX, newY, nextId++);
    newNode.connectTo(parent);
    newNode.mutante = mutacionActiva;

    // 🔗 Conexión con hermanos cercanos
    for (Node other : nodes) {
      if (other != parent && dist(newX, newY, other.x, other.y) < 45 && abs(newY - other.y) < 20) {
        newNode.connectTo(other);
      }
    }

    nodes.add(newNode);
    activeNodes.add(newNode);

    parent.children++;
    if (parent.children >= 2) {
      activeNodes.remove(parent);
    }
  }

  for (Node n : nodes) {
    n.display();
  }
}

class Node {
  float x, y;
  int id;
  int children = 0;
  boolean mutante = false;
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
    float vol = constrain(currentVolume * 20.0, 0.2, 2.5);
    float brightness = map(currentVolume, 0, 0.1, 50, 255);

    color baseColor = mutacionActiva ? color(255, 100, 50) : color(100, 200, 255);
    stroke(lerpColor(baseColor, color(0, 255, 150), id / float(maxNodes)));
    strokeWeight(mutante ? 1.5 : 0.5);

    for (Node other : connections) {
      if (mutacionActiva) {
        float offset = random(-2, 2);
        line(x + offset, y + offset, other.x + offset, other.y + offset);
      } else {
        line(x, y, other.x, other.y);
      }
    }

    noStroke();
    fill(brightness);
    float size = mutante ? 8 * vol : 4 * vol;
    ellipse(x, y, size, size);
  }
}
