//

class Button {
  float xPos, yPos;
  float bWidth, bHeight;
  String type;
  boolean bOver, bLock;
  
  Button(String t) {
    type = t;
    bOver = false;
    bLock = false;
  }
  
  void draw(float x, float y, float w, float h) {
    xPos = x;
    yPos = y;
    bWidth = w;
    bHeight = h;    
    
    if(type == "circle") {
      float d = bWidth;
      if(bOver || bLock) {
        d = bWidth*4/3;
      } else {
        d = bWidth;
      }
      //ellipse(xPos, yPos, bWidth, bHeight);
      ellipse(xPos, yPos, d, d);
    } else if(type == "rotate") {
      if(bOver || bLock) {
        fill(40, 120);
      } else {
        noFill();
      }
      ellipse(xPos, yPos, bWidth, bHeight);
    } else if(type == "animation") {
      if(bOver || bLock) {
        fill(40, 120);
      } else {
        noFill();
      }
      rect(xPos, yPos, bWidth, bHeight, 5);
    }
    
    bOver = over();
  }
  
  boolean over() {
    if(type == "circle" || type == "rotate") {
      if (mouseX >= xPos-bWidth/2 && mouseX <= xPos+bWidth/2 && mouseY >= yPos-bHeight/2 && mouseY <= yPos+bHeight/2) {
        return true;
      } else {
        return false;
      }
    } else if(type == "animation") {
      if (mouseX >= xPos && mouseX <= xPos+bWidth && mouseY >= yPos && mouseY <= yPos+bHeight) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
  
}
