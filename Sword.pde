// sword model to visualize individual behavior

class Sword {  
  float xPos, newxPos;
  float yPos, newyPos;
  float xposMin = 10;
  float xposMax = width-imgWidth*scaleFactor-30;
  float yposMin = 10;
  float yposMax = height-10;  
  float Width;  // width of the middle part (trunk)
  float Height; // height of the middle part (trunk)
  int interval = 20;
  
  float loose = 1;  // how loose/heavy  
  boolean sOver;
  boolean locked;
  
  int selectPixel;
  float[] pValue;
  float[] nDegree;
  int pValueTimeline;
  int nDegreeTimeline;
  
  
  Sword(float x, float y, float w) {    
    xPos = x;
    yPos = y;
    newxPos = xPos;
    newyPos = yPos;    
    Width = w;
    Height = Width/30;
    
    sOver = false;
    locked = false;
  }
  
  void draw(int sP, float[][] pV, int pVT, float[][] nD, int nDT) { 
    selectPixel = sP;
    pValueTimeline = pVT;
    nDegreeTimeline = nDT;
    pValue = new float[pValueTimeline];
    nDegree = new float[nDegreeTimeline];
    for (int i=0; i<pValueTimeline; i++) {
      pValue[i] = pV[i][selectPixel]/16;
    }
    for (int i=0; i<nDegreeTimeline; i++) {
      nDegree[i] = nD[i][selectPixel];
    }
    
    //Width = w;
    update();
    
    // trunk
    fill(30);
    noStroke();
    rect(xPos, yPos, Width+1, Height);
    triangle(xPos+Width, yPos, xPos+Width, yPos+Height, xPos+Width+Height*3/2, (yPos*2+Height)/2);
    ellipse(xPos+Width+Height*3/2, (yPos*2+Height)/2, Height/3, Height/3);
        
    draw_pValue();
    draw_gColor();
    draw_iColor();
    draw_detail();
    
    // square-circle
    noFill();
    stroke(25);
    strokeWeight(1);
    if(gColorFile.value[currentFrame][selectPixel] == 0) {
      fill(clusterColor[top]);
    } else {
      fill(clusterColor[(int)gColorFile.value[currentFrame][selectPixel]-1]);
    }
    rect(xPos-Height*3/2, yPos-Height/2, Height*3/2, Height*2);
    if(iColorFile.value[currentFrame][selectPixel] == 0) {
      fill(clusterColor[top]);
    } else {
      fill(clusterColor[(int)iColorFile.value[currentFrame][selectPixel]-1]);
    }
    ellipse(xPos-Height*3/4, (yPos*2+Height)/2, Height, Height);
    //line(xPos, yPos+Height, xPos-Height/2, yPos+Height*3/2);
    for(int i=0; i<count; i++) {
      if(pixelID[i] == selectPixel) {
        fill(selectColor2[i]);
        triangle(xPos-Height*3/2, yPos-Height/2, xPos-Height, yPos-Height/2, xPos-Height*3/2, yPos);
      }
    } 
    
  } // draw
  
  void draw_pValue() {
    pValueMin = getMin(pValue, pValueTimeline);
    pValueMax = getMax(pValue, pValueTimeline);
    float deltaX = Width/(frameEnd-frameStart);
    stroke(color(188,189,34));
    strokeWeight(1);
    beginShape();
    for (int i=frameStart; i<frameEnd; i++) {
      float x = map(i, frameStart, frameEnd, xPos, xPos+Width) + deltaX/2;;
      float y = map(pValue[i], pValueMin, pValueMax, yPos+Height-2, yPos+2);
      vertex(x, y); 
    }
    endShape();
    
    // time labels    
    int deltaTime = (frameEnd - frameStart)/20;
    for (int j=frameStart; j<frameEnd; j=j+deltaTime) {
      float xT = map(j, frameStart, frameEnd, xPos, xPos+Width) + deltaX/2;
      stroke(250);
      strokeWeight(1);
      line(xT, yPos+Height-1, xT, yPos+Height*4/5); 
      fill(250);
      textSize(Height/4);
      textAlign(CENTER, BOTTOM);
      text(j, xT, yPos+Height*4/5-1);
    }
  } // draw_pValue
  
  void draw_gColor() {   
    float deltaX = Width/(frameEnd-frameStart);
    for (int i=0; i<min(nDegreeTimeline, frameEnd); i++) {
      float x = map(i+(int)winSize/2, frameStart, frameEnd, xPos, xPos+Width);
      float y = map(nDegree[i], nDegreeMin, nDegreeMax, yPos-Height/5, yPos-Height*5);
      if(x >= xPos && x+deltaX+1 <= xPos+Width) {
        if(gColorFile.value[i][selectPixel] != 0) {
          fill(clusterColor[(int)gColorFile.value[i][selectPixel]-1]);
        } else {
          fill(clusterColor[top]);
        }
        noStroke();
        rect(x, y, deltaX+1, yPos-y);
        ellipse(x+deltaX/2, y, deltaX, deltaX);
      }   
    }
    for(int j=min(nDegreeTimeline, frameEnd); j<frameEnd; j++) {
      float x = map(j, frameStart, frameEnd, xPos, xPos+Width);
      float y = map(0, nDegreeMin, nDegreeMax, yPos-Height/5, yPos-Height*5);
      fill(clusterColor[top]);
      noStroke();
      rect(x, y, deltaX+1, yPos-y);
      ellipse(x+deltaX/2, y, deltaX, deltaX);
    }
  } // draw_gColor
  
  void draw_iColor() {
    float deltaX = Width/(frameEnd-frameStart);
    for (int i=0; i<min(nDegreeTimeline,frameEnd); i++) {
      float x = map(i+(int)winSize/2, frameStart, frameEnd, xPos, xPos+Width) + deltaX/2;
      float y = map(nDegree[i], nDegreeMin, nDegreeMax, yPos+Height+Height/5, yPos+Height*6);
      if(x-deltaX/2 >= xPos && x+deltaX/2+1 <= xPos+Width) {
        if(iColorFile.value[i][selectPixel] != 0) {
          stroke(clusterColor[(int)iColorFile.value[i][selectPixel]-1]);
        } else {
          stroke(clusterColor[top]);
        }
        noFill();
        strokeWeight(deltaX/2);
        line(x, y, x, yPos+Height);
        strokeWeight(deltaX);
        point(x, y);
      }
      // click the point 
      if (mousePressed && abs(mouseX-x) < deltaX/2 && abs(mouseY-y) < deltaX/2 && x < xposMax) {
        currentFrame = i;
        drawDetail = true;
        println("currentFrame " + currentFrame);
      }
    }
    for(int j=min(nDegreeTimeline, frameEnd); j<frameEnd; j++) {
      float x = map(j, frameStart, frameEnd, xPos, xPos+Width) + deltaX/2;
      float y = map(0, nDegreeMin, nDegreeMax, yPos+Height+Height/5, yPos+Height*6);
      noFill();
      stroke(clusterColor[top]);
      strokeWeight(deltaX/2);
      line(x, y, x, yPos+Height);
      strokeWeight(deltaX);
      point(x, y);
    }
  } // draw_iColor  
  
  void draw_detail() {
    if(drawDetail) {
      translate(0, 0, 1);
      float deltaX = Width/(frameEnd-frameStart);
      float x = map(currentFrame+(int)winSize/2, frameStart, frameEnd, xPos, xPos+Width) + deltaX/2;
      float y = map(nDegree[currentFrame], nDegreeMin, nDegreeMax, yPos+Height+Height/5, yPos+Height*6);
      if(x >= xPos && x <= xPos+Width) {
        stroke(20);
        strokeWeight(deltaX/4);
        fill(245);
        rect(x+deltaX/4, y+deltaX/4, (12*deltaX/2)*9, (12*deltaX/2)*6);
        
        // cross to close detail
        line(x+deltaX/4+(12*deltaX/2)*9 - 12*deltaX/4, y+deltaX/4 + deltaX/2, x+deltaX/4+(12*deltaX/2)*9 - deltaX/2, y+deltaX/4 + 12*deltaX/4);
        line(x+deltaX/4+(12*deltaX/2)*9 - deltaX/2, y+deltaX/4 + deltaX/2, x+deltaX/4+(12*deltaX/2)*9 - 12*deltaX/4, y+deltaX/4 + 12*deltaX/4);
        if(abs(x+deltaX/4+(12*deltaX/2)*9 - deltaX*7/4 - mouseX) <= deltaX*7/4 && abs(y+deltaX/4 + deltaX*7/4 - mouseY) <= deltaX*7/4 && mousePressed) {
          drawDetail = false;
        }
        
        fill(10);
        textSize(12*deltaX/4);
        textAlign(LEFT, TOP);
        text("Frame No.: " + (currentFrame+(int)winSize/2), x+deltaX, y+deltaX/2);
        text("Node Position: " + selectPixel%imgWidth + ", " + selectPixel/imgWidth, x+deltaX, y+deltaX/2+12*deltaX/2);
        text("Node Value: " + int(pValue[currentFrame]), x+deltaX, y+deltaX/2+(12*deltaX/2)*2);
        text("Node Degree: " + int(nDegree[currentFrame]), x+deltaX, y+deltaX/2+(12*deltaX/2)*3);
        text("Node Consistency: " + homing[selectPixel], x+deltaX, y+deltaX/2+(12*deltaX/2)*4);
        text("Node Switchingness: " + switching[selectPixel], x+deltaX, y+deltaX/2+(12*deltaX/2)*5);        
      }
      translate(0, 0, -1);
    }
  } // draw_detail
  
  void update() {
    sOver = over((xPos-Height*3/4)-Height/2, yPos, (xPos-Height*3/4)+Height/2, yPos+Height);
    if (locked) {
      newxPos = constrain(mouseX, xposMin, xposMax) + Height*3/4; 
      newyPos = constrain(mouseY, yposMin, yposMax) - Height/2; 
    }
    if (sqrt(sq(newxPos-xPos)+sq(newyPos-yPos)) > 1) {
      xPos = xPos + (newxPos-xPos)/loose;
      yPos = yPos + (newyPos-yPos)/loose;
    }

    // press the area to change the width/height of the sword
    if(abs(xPos+Width+Height*3/2 - mouseX) <= Height/3 && abs((yPos*2+Height)/2 - mouseY) <= Height/3 && mousePressed) {
      Width = mouseX - Height*3/2 - xPos;
      //Height = Width/20;
    }
    Height = Width/30;
  } // update
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  boolean over(float x0, float y0, float x1, float y1) {
    if (mouseX > x0 && mouseX < x1 && mouseY > y0 && mouseY < y1) {
      return true;
    } else {
      return false;
    }
  }
  
}

