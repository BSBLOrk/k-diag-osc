import oscP5.*;
import netP5.*;

interface ObservingInstrument {
  void playNote(float freq);
  void playNote(float freq, float velocity);
  void pingMsg(String s);
  
} 

interface OSCObserver {
  NetAddress getRemoteLocation();
  void sendOSC();
}

class OSCObservingInstrument implements ObservingInstrument {
  OscP5 oscP5;
  NetAddress myRemoteLocation;

  OSCObservingInstrument(int remotePort) {
    oscP5 = new OscP5(this,9003);
    //myRemoteLocation = new NetAddress("127.0.0.1",9004);
    myRemoteLocation = new NetAddress("127.0.0.1",remotePort);     
  }
  
  void playNote(float freq) {
    playNote(freq,freq);
  }
  
  void playNote(float freq, float velocity) {
    println("AAAA playNote " + freq + ", " + velocity);
    OscMessage vel = new OscMessage("/velocity");
    OscMessage pitch = new OscMessage("/pitch");   
    pitch.add(map(freq,0,1000,0,127));
    vel.add(map(velocity,0,1000,0,127));
    oscP5.send(pitch, myRemoteLocation);   
    oscP5.send(vel, myRemoteLocation); 
  }
 
  void pingMsg(String s) {
    println(s);
  }

}