

Camouse camouse;
 
IControlAutomaton kDiag;

void settings() {
  size(640,480);
}

void setup() {
  kDiag = new KDiag(240,15,6);
  kDiag.reset();
  
  frameRate(20);
  kDiag.sizeInSetup();
   
  kDiag.addObservingInstrument(new OSCObservingInstrument());  

  camouse = new Camouse(this); 
}
 

void draw() {
  camouse.draw();
  image(camouse.getVideo(), 0, 0);
  tint(70, 30, 40);
  
  kDiag.nextStep();  
  kDiag.draw();

  stroke(255);
  ellipse(camouse.x(), camouse.y(), 10, 10);
  
  kDiag.struck(camouse.x(), camouse.y());
}

void mouseClicked() {
  kDiag.struck(mouseX,mouseY);
}

void keyPressed() {
  kDiag.keyPressed(key);
}