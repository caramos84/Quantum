// Activación con sonido
// Carlos Ramos + ChatGPT 4o
// 16/04/2025

// Importación de bibliotecas y definición de funciones
import processing.sound.*;
ArrayList<Node> nodes;
int maxNodes = 800;
int nextId = 0;
AudioIn mic;
Amplitude amp;

void setup(){
  size(600, 600);
  background(0);
  frameRate(30);
  
  nodes = new ArrayList<Node>();
  nodes.add(new Node(width / 2, height - 30, nextId++));  // Desde la parte inferior
  
  // Configración de micrófono y medidor de amplitud
  mic = new AudioIn(this, 0);
  mic.start();
  amp = new Amplitude(this);
  amp.input(mic);
}

void draw() {
  background(0, 25); // Persistencia visual

  float level = amp.analyze();  // Volumen del micrófono

  // Crece si hay suficiente sonido
  if (level > 0.02 && nodes.size() < maxNodes) {
    Node parent = nodes.get(int(random(nodes.size())));
    
    float angle = random(-PI / 6, PI / 6);  // -30° a 30° de inclinación
    float distance = random(80, 90);
    float newX = parent.x + sin(angle) * distance * 0.8;  // ligera desviación lateral
    float newY = parent.y - abs(cos(angle)) * distance;   // siempre hacia arriba

    Node newNode = new Node(newX, newY, nextId++);
    newNode.connectTo(parent);
    nodes.add(newNode);
  }

  // Dibujar red
  for (Node n : nodes) {
    n.display();
  }
}

class Node{
  float x, y;
  int id;
  ArrayList<Node> connections;
  
  Node(float x, float y, int id){
    this.x = x;
    this.y = y;
    this.id = id;
    connections = new ArrayList<Node>();
  }
  
  void connectTo(Node other){
    connections.add(other);
  }
  
  void display(){
    float pulse = 3 + sin(radians(frameCount + id * 5))*1.5;
    
    stroke(lerpColor(color(200, 100, 255), color(100, 255, 200), id / float(maxNodes)));
    strokeWeight(0.8 + sin(radians(frameCount * 2 + id * 10)) * 0.5);
    for (Node other : connections){
      line(x, y, other.x, other.y);
    }
    
    noStroke();
    fill(255);
    ellipse(x, y, pulse, pulse);
  }
}
