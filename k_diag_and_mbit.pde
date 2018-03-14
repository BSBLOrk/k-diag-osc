

Camouse camouse;
IControlAutomaton kDiag;
IControlAutomaton mBit;



void settings() {
  size(640,480);
}

void setup() {
  kDiag = new KDiag(240,15,6);
  kDiag.reset();
  
  //mBit = new MbitListener(this);
  //mBit.reset();
  
  frameRate(20);
  kDiag.sizeInSetup();
  
  OSCObservingInstrument max = new OSCObservingInstrument(5001);
  kDiag.addObservingInstrument(max);
  //mBit.addObservingInstrument(max);

  camouse = new Camouse(this); 
  
  setupParams();
  
  paramFont = loadFont("Dialog.plain-12.vlw");

}
 

void draw() {
  camouse.draw();
  image(camouse.getVideo(), 0, 0);
  tint(70, 30, 40);
  
  kDiag.nextStep();  
  kDiag.draw();

  //mBit.nextStep();
  
  stroke(255);
  ellipse(camouse.x(), camouse.y(), 10, 10);
  
  kDiag.struck(camouse.x(), camouse.y());
  
  
  
  for (Param p : paramList) {
    p.next();
    p.draw();
  }
}

void mouseClicked() {
  kDiag.struck(mouseX,mouseY);
  //mBit.struck(mouseX,mouseY);
  for(Param p : paramList) {
      if (p.hit(mouseX,mouseY)) {
        p.setDestination(mouseX,mouseY);
        break;
      }
   }
}

void keyPressed() {
  kDiag.keyPressed(key);
  //mBit.keyPressed(key);
}