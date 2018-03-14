interface ISimpleAutomaton {
  void next();
  void draw();
  boolean isPlaying();
}

PFont paramFont;

class Param extends TimeSlider implements OSCObserver, ISimpleAutomaton  {
  String title;
  String type;
  float min,max;
  String path;
  OscP5 oscP5;
  NetAddress myRemoteLocation; 
  
  boolean playing=true;
  float a=0;
  float da=0.001;
  int c,dc;
  
  Param(int remotePort,String tit, String typ, float min, float max, String pName) {
    
    super(0, 0, min, max);

    title = tit;
    type = typ;
    this.min = min;
    this.max = max;
    this.path = "/"+pName;

    oscP5 = new OscP5(this,9003);
    myRemoteLocation = new NetAddress("127.0.0.1",remotePort);     
    da = random(1)/1000;
    c = 0;
    dc = (int)  random(10);
  }

  void setCorner(int xx, int yy) {
    x = xx;
    y = yy;
  }
  
  void next() {
    update();
    if (moving) {
      sendOSC();
    }
  }
  
  void draw() {
    draw(color(100,100,255,0));
    textFont(paramFont);
    stroke(255);
    fill(255);
    text(path,x,y);
  }

  String pp() {
    return title+ ": ("+type+") " + min + "-" + max + "  " + path;
  }
  
  NetAddress getRemoteLocation() {
      return myRemoteLocation;
  }
  
  void sendOSC() {
      OscMessage m = new OscMessage(path);
      float v = getValue();      
      if (type=="int") {
        m.add((int)v);
      } else {
        m.add(v);
      }      
      oscP5.send(m, myRemoteLocation);    
  }
  
  boolean isPlaying() { return playing; }
  
}

ArrayList<Param> paramList = new ArrayList<Param>();
void setupParams() {
  paramList.add(new Param(5001,"harm_(LFO)_time_(envelope_duration_in_ms)","int",1,1024,"harm_time"));
  paramList.add(new Param(5001,"harm_(LFO)_depth_(intensity)","float",0,1024,"harm_depth"));
  paramList.add(new Param(5001,"harm_(LFO)_freq_","float",0,1024,"harm_freq"));
  paramList.add(new Param(5001,"harm_(LFO)_range","float",0,1024,"harm_range"));
  paramList.add(new Param(5001,"mod_(LFO)_time_(envelope_in_ms)","int",1,1024,"mod_time"));
  paramList.add(new Param(5001,"mod_(LFO)_depth_(intensity)","float",0,1024,"mod_depth"));
  paramList.add(new Param(5001,"mod_(LFO)_freq_","float",0,1024,"mod_freq"));
  paramList.add(new Param(5001,"mod_(LFO)_range","float",0,1024,"mod_range"));
  paramList.add(new Param(5001,"shift_(LFO)_time_(envelope_in_ms)","int",1,1024,"shift_time"));
  paramList.add(new Param(5001,"shift_(LFO)_depth_(intensity)","float",0,1024,"shift_depth"));
  paramList.add(new Param(5001,"shift_(LFO)_freq_","float",0,1024,"shift_freq"));
  paramList.add(new Param(5001,"shift_(LFO)_range","float",0,1024,"shift_range"));
  paramList.add(new Param(5001,"amp_(LFO)_time_(envelope_in_ms)","int",1,1024,"amp_time"));
  paramList.add(new Param(5001,"amp_(LFO)_depth_(intensity)","float",0,2,"amp_depth"));
  paramList.add(new Param(5001,"amp_(LFO)_freq_","float",0,1024,"amp_freq"));
  paramList.add(new Param(5001,"amp_(LFO)_range","float",0,1024,"amp_range"));
  paramList.add(new Param(5001,"vib_(LFO)_time_(envelope_in_ms)","int",1,1024,"vib_time"));
  paramList.add(new Param(5001,"vib_(LFO)_depth_(intensity)","float",0,1024,"vib_depth"));
  paramList.add(new Param(5001,"vib_(LFO)_freq_","float",0,1024,"vib_freq"));
  paramList.add(new Param(5001,"vib_(LFO)_range","float",0,1024,"vib_range"));
  paramList.add(new Param(5001,"reverb_size","int",0,127,"rev_size"));
  paramList.add(new Param(5001,"reverb_decay","int",0,127,"rev_decay"));
  paramList.add(new Param(5001,"reverb_damp","int",0,127,"rev_damp"));
  paramList.add(new Param(5001,"reverb_diff","int",0,127,"rev_diff"));

  int xx=10; 
  int yy=10;
  for (Param p : paramList) {
    p.setCorner(xx,yy);
    println(p.pp());
    xx=(xx+(int)p.w+5)%550;
    if (xx<p.w+10) {
      yy=(yy+(int)p.h+5);
      xx=10;
    }
  }
}