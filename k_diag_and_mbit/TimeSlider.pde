
class TimeSlider {
  float x, y, w, h; // absolute pixels
  float slideBottom, slideTop, targetMin, targetMax;

  float current, destination; // offsets from y
  float dy; 
  boolean moving;
  
  TimeSlider(int x, int y, float targetMin, float targetMax) {
    this.x = x;
    this.y = y;
    this.w = 70;
    this.h = 140;
    this.targetMin = targetMin;
    this.targetMax = targetMax;
    this.slideBottom = h;
    this.slideTop = 0;
    
    current = h/2;
    moving = false;
  }
  
  
  void draw(color wash) {
    stroke(50,50,255);
    fill(wash);
    rect(x,y,w,h);
    noFill();

    stroke(0,255,0);
    line(x,y+current,x+w,y+current);
    stroke(255,255,0);
    line(x,y+destination,x+w,y+destination);

  }
  
  boolean hit(int mouseX, int mouseY) {
    if (mouseX < x) { return false; }
    if (mouseX > x+w) { return false; }
    if (mouseY < y) { return false; }
    if (mouseY > y+h) { return false; }
    return true;
  }
 
  boolean closish(float x, float target, float margin) {
    if (x < target-margin) { return false; }
    if (x > target+margin) { return false; }
    return true;
  }
    
  void setDestination(int mouseX, int mouseY) {
    float dx = mouseX - x;
    destination = mouseY-y;  
    if (dx < 1) { dx = 1; }
    dy = ((mouseY-y) - current) / (dx*100);   
    moving = true;
  }
  
  void update() {

    if (moving && (!closish(current,destination,1)) && (current<h)) {
      current = current+dy;
    } else {
      moving = false;
    }
  }
  
  float getValue() {
    return map(current,h,0,targetMin,targetMax);
  }
}