
void mouseClicked() {
  imgOver(width-imgWidth*scaleFactor-10, 10, width-10, 10+imgHeight*scaleFactor);
  
  // buttons for recommendation
  for(int i=0; i<top; i++) {
    if(topCommButton[i].bOver) {
      if(topCommButton[i].bLock) {
        topCommButton[i].bLock = false;
      } else {
        topCommButton[i].bLock = true;
      }
    }
    if(topDegreeButton[i].bOver) {
      if(topDegreeButton[i].bLock) {
        topDegreeButton[i].bLock = false;
      } else {
        topDegreeButton[i].bLock = true;
        selectColor2[count] = degreeColor[i];
        pixelID[count++] = topDegree[i];
      }
    }
    if(topStableButton[i].bOver && count < top) {
      if(topStableButton[i].bLock) {
        topStableButton[i].bLock = false;
      } else {
        topStableButton[i].bLock = true;
        selectColor2[count] = stableColor[i];
        pixelID[count++] = topStable[i];
      }
    }
  }
  
  // remove selected nodes
  for(int i=0; i<top; i++) {
    if(selectedButton[i].bOver && pixelID[i] >= 0) {
      pixelID[i] = -1;      
      for(int j=i; j<top-1; j++) {
        pixelID[j] = pixelID[j+1];
        selectColor2[j] = selectColor2[j+1];
      }
      pixelID[top-1] = -1;
      count--;
      println("count: " + count);
      break;
    }
  }
  
  // check box for 3D views
  if(spaceT.cOver) {
    if(spaceT.checked) {
      spaceT.checked = false;
      //spaceA.checked = true;
    } else {
      spaceT.checked = true;
      spaceA.checked = false;
    }
  }  
  if(spaceA.cOver) {
    if(spaceA.checked) {
      spaceA.checked = false;
      //spaceA.checked = true;
    } else {
      spaceA.checked = true;
      spaceT.checked = false;
      //currentFrame = frameStart-(int)winSize/2;
    }
  }
  
  // button rotations for 3D view
  if (xRotation[0].bOver) {
    rotateX -= 0.1;
  } else if (xRotation[1].bOver) {
    rotateX += 0.1;
  } else if (zRotation[0].bOver) {
    rotateZ -= 0.1;
  } else if (zRotation[1].bOver) {
    rotateZ += 0.1;
  } else if (yRotation[0].bOver) {
    rotateY -= 0.1;
    //rotateRate = rotateRate/2;
  } else if (yRotation[1].bOver) {
    rotateY += 0.1;
    //rotateRate = rotateRate*2;
  }
  
  // button for animation
  if (play.bOver) {
    play.bLock = true;
    pause.bLock = false;
    stop.bLock = false;
  }
  if (pause.bOver) {
    play.bLock = false;
    pause.bLock = true;
    stop.bLock = false;
  }
  if (stop.bOver) {
    play.bLock = false;
    pause.bLock = false;
    stop.bLock = true;
    currentFrame = frameStart-(int)winSize/2;
  }
  //
}


void imgOver(float x0, float y0, float x1, float y1) {
  if (mouseX>=x0 && mouseX<=x1 && mouseY >=y0 && mouseY <= y1 && mouseButton==LEFT) {
    if(sliceImgs && count < top) {
      selectColor2[count] = selectColor[count];
      pixelID[count++] = int((mouseY-y0)/scaleFactor)*imgWidth + int((mouseX-x0)/scaleFactor);
      println("current pixel ID: " + pixelID[count-1]);
    }
  }
}


void mousePressed() {
  for(int i=0; i<top; i++) {
    if(sword[i].sOver) {
      sword[i].locked = true;
      break;
    }
  }
}


void mouseReleased() {
  timeSlider.lockedStart = false;
  timeSlider.lockedEnd = false;
  degreeSlider.lockedStart = false;
  degreeSlider.lockedEnd = false;
  homingSlider.lockedStart = false;
  homingSlider.lockedEnd = false;
  switchSlider.lockedStart = false;
  switchSlider.lockedEnd = false;
  
  //currentFrame = frameStart-(int)winSize/2;
  
  for(int i=0; i<top; i++) {
    sword[i].locked = false;    
  } 
  
  println("frameStart: " + frameStart);
  println("frameEnd: " + frameEnd);
  println("degreeStart: " + degreeStart);
  println("degreeEnd: " + degreeEnd);
  println("homingStart: " + homingStart);
  println("homingEnd: " + homingEnd);
  println("switchStart: " + switchStart);
  println("switchEnd: " + switchEnd);
}


void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT && currentFrame > 0) {
      currentFrame--;
    } else if(keyCode == RIGHT && currentFrame < nDegreeFile.timeline-1) {
      currentFrame++;
    } else if(keyCode == RIGHT && currentFrame == nDegreeFile.timeline-1) {
      currentFrame = 0;
    } else if(keyCode == UP) {
      shiftY--;
    } else if(keyCode == DOWN) {
      shiftY++;
    } 
  } else if(key == ' ') {
      rotateX = 0;
      rotateY = 0;
      rotateZ = 0;
  }
}
