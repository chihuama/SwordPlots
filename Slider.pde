// sliders for filtering

class Slider {
  float xPos, yPos;
  float sWidth, sHeight;
  float sPosStart, newsPosStart;    // x position of slider for starting point
  float sPosEnd, newsPosEnd;        // x position of slider for ending point
  float sPosMin, sPosMax;           // max and min values of slider
  float loose = 1;                  // how loose/heavy
  boolean lockedStart = false;
  boolean lockedEnd = false;
  
  float sValueStart, sValueEnd;
  float sValueMin, sValueMax;
  int interval = 10;
  String type;
  
  Slider(float x0, float y0, float x1, float y1, float sVstart, float sVend, float sVmin, float sVmax, String t) {
    xPos = x0;
    yPos = y0;
    sWidth = x1-x0;
    sHeight = y1-y0;
    
    sValueStart = sVstart;
    sValueEnd = sVend;
    sValueMin = sVmin;
    sValueMax = sVmax;
    
    sPosStart = xPos + sWidth*sValueStart/(sValueMax-sValueMin);
    newsPosStart = sPosStart;
    sPosEnd = xPos + sWidth*sValueEnd/(sValueMax-sValueMin);
    newsPosEnd = sPosEnd;
    
    sPosMin = xPos;
    sPosMax = xPos + sWidth; 
    
    type = t;
  }
  
  void draw() {
    update();
    display();
    drawLabels();
  }
  
  void update() {
    if (mousePressed && overEnd()) {
      lockedEnd = true;
      lockedStart = false;
    }
    if (mousePressed && overStart()) {
      lockedStart = true;
      lockedEnd = false;
    }
    
    if (lockedEnd) {
      newsPosEnd = constrain(mouseX, sPosStart+1, sPosMax);
    }
    if (abs(newsPosEnd - sPosEnd) > 1) {
      sPosEnd = sPosEnd + (newsPosEnd-sPosEnd)/loose;
    }    
    
    if (lockedStart) {
      newsPosStart = constrain(mouseX, sPosMin, sPosEnd-1); 
    }
    if (abs(newsPosStart - sPosStart) > 1) {
      sPosStart = sPosStart + (newsPosStart-sPosStart)/loose;
    }
  } // update
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  boolean overStart() {
    if (mouseX > sPosStart-sHeight*2/3 && mouseX < sPosStart+sHeight*2/3 && mouseY > yPos-sHeight*2/3 && mouseY < yPos+sHeight*2/3 && !lockedEnd) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean overEnd() {
    if (mouseX > sPosEnd-sHeight*2/3 && mouseX < sPosEnd+sHeight*2/3 && mouseY > yPos-sHeight*2/3 && mouseY < yPos+sHeight*2/3 && !lockedStart) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    noFill();
    stroke(25);
    strokeWeight(1);
    rect(xPos, yPos, sWidth, sHeight, 5);
    
    // fill between start and end point on the slider
    noStroke();
    fill(25);
    rect(sPosStart, yPos, sPosEnd-sPosStart, sHeight);
    
    translate(0, 0, 1);
    stroke(35);
    if (overStart() || lockedStart) {
      fill(40);
    } else {
      fill(80);
    }
    ellipse(sPosStart, yPos+sHeight/2, sHeight*4/3, sHeight*4/3); 
    if (overEnd() || lockedEnd) {
      fill(40);
    } else {
      fill(80);
    }
    ellipse(sPosEnd, yPos+sHeight/2, sHeight*4/3, sHeight*4/3);
    translate(0, 0, -1);
    
    sValueStart = (sPosStart-xPos)*(sValueMax-sValueMin)/sWidth;
    sValueEnd = (sPosEnd-xPos)*(sValueMax-sValueMin)/sWidth;
  }// display
  
  void drawLabels() {
    fill(10);
    stroke(25);
    strokeWeight(1);
    textSize(8);
    textAlign(CENTER, TOP);    
    for(int i=0; i<=interval; i++) {
      float x = map(i, 0, interval, xPos+1, xPos+sWidth-1);
      float v = (sValueMax-sValueMin)*i/interval;      
      line(x, yPos+sHeight*3/2, x, yPos+sHeight*2);      
      if(type == "int") {
        text(""+(int)v, x, yPos+sHeight*2);
      } else {
        text(""+v, x, yPos+sHeight*2);
      }
    }
  } // drawLabels
}
