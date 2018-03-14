
import processing.serial.*;
import oscP5.*;
import netP5.*;

class MbitListener  implements IControlAutomaton {
  Serial myPort;
  boolean playing = false;
  int old_a = 0;
  IFreqStrategy fs = new IdentityFreqStrategy();
  ArrayList<ObservingInstrument> obis = new ArrayList<ObservingInstrument>();

  MbitListener(PApplet pa) {
    if (Serial.list().length > 0) {   
      myPort = new Serial(pa, Serial.list()[0], 115200);
    } else {
      println("No serial found");
    }    
  }

  boolean isPlaying() { 
    return playing;
  }

  void start() { 
    playing = true;
  }
  
  void stop() {
    playing = false;
  }

  void sizeInSetup() {}

  void setIFreqStrategy(IFreqStrategy fs) { 
    this.fs = fs;
  }
  IFreqStrategy getIFreqStrategy() { 
    return fs;
  }
  void struck(int x, int y) {  }
  void reset() {  }
  void draw() { }
  
  /*
  void send(String chan, float num) {
    
    OscMessage out = new OscMessage(chan);
    out.add(num);
    oscP5.send(out,addresses);
    
  }
  */
  
  void playNote(float freq, float velocity) {
    if (isPlaying()) {
      println("HHH " + freq + " " + velocity);
      for (ObservingInstrument oi : obis) {
        oi.pingMsg("instrument pinged from mbit");
        oi.playNote(freq,velocity);
      }
    }
  }


  void nextStep() {
    int x, y, z, a, b;
    while (myPort.available() > 0) {

      String inBuffer = myPort.readString(); 
      if (inBuffer != null) {
        try {
          inBuffer = inBuffer.trim();
          String[] parts = inBuffer.split(",");
          x = Integer.parseInt(parts[0]);
          y = Integer.parseInt(parts[1]);
          z = Integer.parseInt(parts[2]);
          a = Integer.parseInt(parts[3]);
          b = Integer.parseInt(parts[4]);
        } 
        catch (Exception e) {
          println("Exception " + e);
          return;
        }
        //println("x:" + x + ", y:" + y + ", z:" + z + ", a:" + a + ", b:" + b + " " + playing);

        if ((b==1) || playing) {
         println("== x:" + x + ", y:" + y + ", z:" + z + ", a:" + a + ", b:" + b + " " + playing);

          playNote(map(x, -1024, 1024, 0, 1000), map(y, -1024, 1024, 0, 1000));
          //playNote(fs.corrected(fs.rawFreq(x)), fs.corrected(fs.rawFreq(y)));
          /*
          send("/AL", map(x, -1024, 1024, 0, 127));
          send("/ML", map(y, -1024, 1024, 0, 127));
          send("/BS", map(y, -1024, 1024, 0, 127));
          */
        }

        if (a != old_a) {
          println("++ x:" + x + ", y:" + y + ", z:" + z + ", a:" + a + ", b:" + b + " " + playing);

          playing = !playing;
          if (!playing) {
            playNote(0,0);
            /*
            send("/AL", 0);
            send("/ML", 0);
            send("/BS", 0);
            */
          }
        }
        old_a = a;
      }
    }
  }
  
  void keyPressed(int c) { }
  
  void addObservingInstrument(ObservingInstrument oi) {
    obis.add(oi); 
  }
  
}