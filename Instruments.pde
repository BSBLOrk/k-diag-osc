import oscP5.*;
import netP5.*;

interface ObservingInstrument {
  void playNote(float freq);
} 


class OSCObservingInstrument implements ObservingInstrument {
  OscP5 oscP5;
  NetAddress myRemoteLocation;

  OSCObservingInstrument() {
    oscP5 = new OscP5(this,9003);
    //myRemoteLocation = new NetAddress("127.0.0.1",9004);
    myRemoteLocation = new NetAddress("127.0.0.1",5001);     
  }
  
  void playNote(float freq) {
    println("playNote " + freq);
    OscMessage vol = new OscMessage("/velocity");
    OscMessage pitch = new OscMessage("/pitch");   
    pitch.add(map(freq,0,1000,0,127));
    vol.add(map(freq,0,1000,0,127));
    oscP5.send(pitch, myRemoteLocation);   
    oscP5.send(vol, myRemoteLocation); 
  }
}