//

class CheckBox {
  float xPos, yPos;
  float cbSize;
  String name;
  boolean cOver;
  boolean checked;
  
  CheckBox(float x, float y, float w, String s, boolean c) {
    xPos = x;
    yPos = y;
    cbSize = w;
    name = s;
    checked = c;
  }
  
  void draw() {
    noFill();
    stroke(20);
    strokeWeight(1);
    rect(xPos, yPos, cbSize, cbSize);
    
    cOver = over();
    
    if(checked) {
      line(xPos+2, yPos+2, xPos+cbSize-2, yPos+cbSize-2);
      line(xPos+2, yPos+cbSize-2, xPos+cbSize-2, yPos+2);
    }
    
    fill(20);
    textSize(12);
    textAlign(LEFT, TOP);
    text(name, xPos+cbSize*2, yPos);
  }
  
  boolean over() {
    if(mouseX > xPos && mouseX < xPos+cbSize && mouseY > yPos && mouseY < yPos+cbSize) {
      return true;
    } else {
      return false;
    }
  }
  
}
