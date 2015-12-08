// visualization of dynamic networks
// individual behavior + 3D views

/* @pjs preload="s19.jpg"; */
import javax.swing.*; 

public boolean preCut = true;
public int caseId = 1;

PImage img;
ReadFile pValueFile;
ReadFile nDegreeFile;
ReadFile iColorFile;
ReadFile gColorFile;
ReadFile statsFile;

public float pValueMin;
public float pValueMax;
public int nDegreeMin;
public int nDegreeMax;

public float radius;
public Button[] topCommButton;
public Button[] topDegreeButton;
public Button[] topStableButton;
public Button[] selectedButton;
public int[] topDegree;
public int[] topStable;

Slider timeSlider;
Slider degreeSlider;
Slider homingSlider;
Slider switchSlider;
public float[] homing;
public float[] absence;
public float[] switching;

public int frameStart = 100;
public int frameEnd = 1000;
public int currentFrame = 0;
public int degreeStart = 0;
public int degreeEnd = 1;
public float homingStart = 0;
public float homingEnd = 1;
public float switchStart = 0;
public float switchEnd = 1;

CheckBox spaceT;
CheckBox spaceA;
public Button[] xRotation;
public Button[] yRotation;
public Button[] zRotation;
public Button play;
public Button pause;
public Button stop;

public boolean rotate = false;
public float rotateRate = 0.006;
public float rotateX = -PI/18.0;
public float rotateY = 0;
public float rotateZ = 0;
public float shiftY = 0;
public float play_delta = 0;

Sword[] sword;
public int[] pixelID;
public int count = 0;
public boolean drawDetail = false;

public int imgWidth = 172;
public int imgHeight = 130;
public int pixel = 130*172;
public int scaleFactor = 2;

public boolean sliceImgs = true;
public int winSize = 100;
PFont font = createFont("Georgia", 20);

public boolean doneLoading = false;
public float loadingPercent;

/*****************************************************************************************************/

void setup() {
  size(1560, 800, P3D);
  //size(displayWidth, displayHeight, P3D);
  //frameRate(30);
  thread("LoadData");
}


void LoadData() {
  // The thread is not completed
  doneLoading = false;
  loadingPercent = 0;
  
  //****************************** loading input files ******************************/
  
  if(caseId == 1) {
    img = loadImage("data/s19.jpg");
    pValueFile = new ReadFile("data/s19_pixelsGreyValue_f2001-3500.txt", pixel);  
    nDegreeFile = new ReadFile("data/s19_nodeDegree_f2001-2500.txt", pixel);  
    iColorFile = new ReadFile("data/s19_icolor_nodeClusterColorTop10_f2001-2500.txt", pixel);  
    gColorFile = new ReadFile("data/s19_gcolor_nodeClusterColorTop10_f2001-2500.txt", pixel);  
    statsFile = new ReadFile("data/s19_ind_stat-c311.csv", 4);  // individual, switching, absence, homing  
  } else if(caseId == 2) {
    img = loadImage("data/s32.jpg");
    pValueFile = new ReadFile("data/s32_pixelsGreyValue_f4001-5999.txt", pixel);  
    nDegreeFile = new ReadFile("data/s32_nodeDegree_f4001-5500.txt", pixel);  
    iColorFile = new ReadFile("data/s32_icolor_nodeClusterColorTop10_f4001-5500.txt", pixel);  
    gColorFile = new ReadFile("data/s32_gcolor_nodeClusterColorTop10_f4001-5500.txt", pixel);  
    statsFile = new ReadFile("data/s32_ind_stat-c311.csv", 4);  // individual, switching, absence, homing 
  } else if(caseId == 3) {
    img = loadImage("data/young35.jpg");
    pValueFile = new ReadFile("data/young35_pixelsGreyValue_f16501-17500.txt", pixel);  
    nDegreeFile = new ReadFile("data/young35_nodeDegree_f16501-16800.txt", pixel);  
    iColorFile = new ReadFile("data/young35_icolor_nodeClusterColorTop10_f16501-16800.txt", pixel);  
    gColorFile = new ReadFile("data/young35_gcolor_nodeClusterColorTop10_f16501-16800.txt", pixel);  
    statsFile = new ReadFile("data/young35_ind_stat-c111.csv", 4);  // individual, switching, absence, homing 
  } else if(caseId == 4) {
    img = loadImage("data/old38.jpg");
    pValueFile = new ReadFile("data/old38_pixelsGreyValue_f350-1349.txt", pixel);  
    nDegreeFile = new ReadFile("data/old38_nodeDegree_f350-549.txt", pixel);  
    iColorFile = new ReadFile("data/old38_icolor_nodeClusterColorTop10_f350-549.txt", pixel);  
    gColorFile = new ReadFile("data/old38_gcolor_nodeClusterColorTop10_f350-549.txt", pixel);  
    statsFile = new ReadFile("data/old38_ind_stat-c111.csv", 4);  // individual, switching, absence, homing 
  }
  
  pValueFile.load();
  loadingPercent += 0.2;
  nDegreeFile.load();
  loadingPercent += 0.2;
  iColorFile.load();
  loadingPercent += 0.2;
  gColorFile.load();
  loadingPercent += 0.2;
  statsFile.load2();
  loadingPercent += 0.2;
  
  println("pValueFile: " + pValueFile.timeline);
  println("nDegreeFile: " + nDegreeFile.timeline);
  println("iColorFile: " + iColorFile.timeline);
  println("gColorFile: " + gColorFile.timeline);
  println("statsFile: " + statsFile.timeline);
  
  pValueMin = getMin(pValueFile.value, pValueFile.timeline, pValueFile.cols)/16;
  pValueMax = getMax(pValueFile.value, pValueFile.timeline, pValueFile.cols)/16;
  nDegreeMin = (int)getMin(nDegreeFile.value, nDegreeFile.timeline, nDegreeFile.cols);
  nDegreeMax = (int)getMax(nDegreeFile.value, nDegreeFile.timeline, nDegreeFile.cols);
  degreeEnd = nDegreeMax;
  println("pMin: " + pValueMin);
  println("pMax: " + pValueMax);
  println("nMin: " + nDegreeMin);
  println("nMax: " + nDegreeMax);
  
  currentFrame = frameStart;
  //frameEnd = pValueFile.timeline;
  
  InitColor();
    
  //******************** intialize top recommended nodes ********************/
  radius = imgWidth*scaleFactor/float(top*3-1);
  topCommButton = new Button[top];
  topDegreeButton = new Button[top];
  topStableButton = new Button[top];
  selectedButton = new Button[top]; 
  topDegree = new int[top];
  topStable = new int[top]; 
  for(int i=0; i<top; i++) {
    topCommButton[i] = new Button("circle");
    topDegreeButton[i] = new Button("circle");
    topStableButton[i] = new Button("circle");
    selectedButton[i] = new Button("circle");
    topDegree[i] = -1;
    topStable[i] = -1;
  }
  
  //******************** intialize filter sliders ********************/
  timeSlider = new Slider(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*18.5, width-20, imgHeight*scaleFactor+20 + radius*19, frameStart, frameEnd, 0, pValueFile.timeline, "int");
  degreeSlider = new Slider(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*22.5, width-20, imgHeight*scaleFactor+20 + radius*23, degreeStart, degreeEnd, 0, nDegreeMax, "int");
  homingSlider = new Slider(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*26.5, width-20, imgHeight*scaleFactor+20 + radius*27, homingStart, homingEnd, 0, 1, "filter");
  switchSlider = new Slider(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*30.5, width-20, imgHeight*scaleFactor+20 + radius*31, switchStart, switchEnd, 0, 1, "filter");
  
  homing = new float[pixel];
  absence = new float[pixel];
  switching = new float[pixel];
  for(int i=0; i<pixel; i++) {
    homing[i] = -1.0;
    absence[i] = -1.0;
    switching[i] = -1.0;
  }
  
  float[] stable = new float[statsFile.timeline];
  for(int j=0; j<statsFile.timeline; j++) {
    homing[(int)statsFile.value[j][0]] = statsFile.value[j][3];
    absence[(int)statsFile.value[j][0]] = statsFile.value[j][2];
    switching[(int)statsFile.value[j][0]] = statsFile.value[j][1];
    //stable[j] = (1-statsFile.value[j][1])*(1-statsFile.value[j][2])*statsFile.value[j][3];
    stable[j] = (1-statsFile.value[j][1])*statsFile.value[j][3];
  }
  
  //******************** calculate top 10 pixel ids ********************/
  float[] totalDegree = new float[pixel];
  for(int i=0; i<pixel; i++) {
    totalDegree[i] = 0;
    for(int j=0; j<nDegreeFile.timeline; j++) {
      totalDegree[i] += nDegreeFile.value[j][i];
    }
  }
  
  for(int k=0; k<top; k++) {
    float max = getMax(stable, statsFile.timeline);
    topStable[k] = (int)statsFile.value[indexMax][0];
    stable[indexMax] = 0;
    
    max = getMax(totalDegree, pixel);
    topDegree[k] = indexMax;
    totalDegree[indexMax] = 0;
  }
  
  //******************** intialize check boxes ********************/
  //spaceT = new CheckBox(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*35, radius, "Space-Time Cube", false);
  //spaceA = new CheckBox(width-imgWidth*scaleFactor/2-10, imgHeight*scaleFactor+20 + radius*35, radius, "Space-Attribute Cube", false);
  spaceT = new CheckBox(width-imgWidth*scaleFactor/2-10, imgHeight*scaleFactor+20 + radius*35, radius, "Space-Time Cube", false);
  spaceA = new CheckBox(width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*35, radius, "Space-Attribute Cube", false);
  
  xRotation = new Button[2];
  yRotation = new Button[2];
  zRotation = new Button[2];
  for(int j=0; j<2; j++) {
    xRotation[j] = new Button("rotate");
    yRotation[j] = new Button("rotate");
    zRotation[j] = new Button("rotate");
  }
  
  play = new Button("animation");
  pause = new Button("animation");
  stop = new Button("animation");
  
  //******************** intialize selected swords ********************/
  //SwordWidth = width-(imgWidth*scaleFactor+20)*2;
  sword = new Sword[top];
  pixelID = new int[top];
  for(int k=0; k<top; k++) {
    sword[k] = new Sword(100, 100+(height-200)*k/top, width-(imgWidth*scaleFactor+20)*2);
    pixelID[k] = -1;
  }
  //  
  // The thread is completed!
  doneLoading = true;
}

/*****************************************************************************************************/

void draw() {
  background(255);  
  
  if(doneLoading) {
  textFont(font);
  //textMode(SHAPE);
  
  //**************************************** control panel ****************************************/
  //translate(0, 0, t);
  int cPanelWidth = imgWidth*scaleFactor+20;
  fill(clusterColor[10]);
  stroke(20);
  strokeWeight(1);
  rect(width-cPanelWidth, 0, cPanelWidth, height);  
  image(img, width-cPanelWidth+10, 10, imgWidth*scaleFactor, imgHeight*scaleFactor);
  
  //*********************************** recommendation buttons ***********************************/  
  fill(20);
  textSize(12);
  textAlign(LEFT, TOP);
  text("Top 10 Communities", width-cPanelWidth+10, imgHeight*scaleFactor+20);
  text("Top 10 Stable Nodes", width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*3.5);
  text("Top 10 Most Connected Nodes", width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*7);  
  text("Selected Nodes (up to 10)", width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*10.5);  
  for(int i=0; i<top; i++) {    
    noStroke();
    fill(clusterColor[i]);
    topCommButton[i].draw(width-cPanelWidth+10 + radius + i*(radius*3), imgHeight*scaleFactor+20 + radius*2.5, radius*2*2/3, radius*2*2/3);
    fill(stableColor[i]);
    topStableButton[i].draw(width-cPanelWidth+10 + radius + i*(radius*3), imgHeight*scaleFactor+20 + radius*6, radius*2*2/3, radius*2*2/3);
    fill(degreeColor[i]);
    topDegreeButton[i].draw(width-cPanelWidth+10 + radius + i*(radius*3), imgHeight*scaleFactor+20 + radius*9.5, radius*2*2/3, radius*2*2/3);    
    
    if(pixelID[i]>=0) {
      fill(selectColor2[i]);
    } else {
      noFill();
    }
    stroke(20);
    strokeWeight(1);
    selectedButton[i].draw(width-cPanelWidth+10 + radius + i*(radius*3), imgHeight*scaleFactor+20 + radius*13, radius*2*2/3, radius*2*2/3);
  }
  
  //**************************************** fliter sliders ****************************************/
  fill(20);
  textSize(14);
  textAlign(LEFT, TOP);
  text("Filters", width-cPanelWidth+35, imgHeight*scaleFactor+20 + radius*14.7);
  
  stroke(20);
  strokeWeight(1);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*15.5, width-cPanelWidth+30, imgHeight*scaleFactor+20 + radius*15.5);
  line(width-cPanelWidth+40+textWidth("Filters"), imgHeight*scaleFactor+20 + radius*15.5, width-10, imgHeight*scaleFactor+20 + radius*15.5);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*15.5, width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*32.5);
  line(width-10, imgHeight*scaleFactor+20 + radius*15.5, width-10, imgHeight*scaleFactor+20 + radius*32.5);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*32.5, width-10, imgHeight*scaleFactor+20 + radius*32.5);
    
  textSize(12);
  text("Time: " + frameStart + " ~ " + frameEnd, width-cPanelWidth+15, imgHeight*scaleFactor+20 + radius*16.5);
  text("Current Time: " + (currentFrame+(int)winSize/2), width-cPanelWidth/2+15, imgHeight*scaleFactor+20 + radius*16.5);
  text("Node Degree: "  + degreeStart + " ~ " + degreeEnd, width-cPanelWidth+15, imgHeight*scaleFactor+20 + radius*20.5);
  text("Node Consistency: "  + nf(homingStart, 1, 2) + " ~ " + nf(homingEnd, 1, 2), width-cPanelWidth+15, imgHeight*scaleFactor+20 + radius*24.5);
  text("Node Switchingness: "  + nf(switchStart, 1, 2) + " ~ " + nf(switchEnd, 1, 2), width-cPanelWidth+15, imgHeight*scaleFactor+20 + radius*28.5);
  
  timeSlider.draw();
  frameStart = round(timeSlider.sValueStart);
  frameEnd = round(timeSlider.sValueEnd);
  degreeSlider.draw();
  degreeStart = round(degreeSlider.sValueStart);
  degreeEnd = round(degreeSlider.sValueEnd);
  homingSlider.draw();
  homingStart = homingSlider.sValueStart;
  homingEnd = homingSlider.sValueEnd;
  switchSlider.draw();
  switchStart = switchSlider.sValueStart;
  switchEnd = switchSlider.sValueEnd;
  
  //**************************************** 2D image panel ****************************************/ 
  // draw selected nodes on the 2d image panel
  for(int i=0; i<top; i++) {
    // Top 10 Communities
    if(topCommButton[i].bLock) {
      for(int j=0; j<pixel; j++) {
        if(iColorFile.value[currentFrame][j] == i+1 
        && nDegreeFile.value[currentFrame][j] >= degreeStart && nDegreeFile.value[currentFrame][j] <= degreeEnd
        && homing[j] >= homingStart && homing[j] <= homingEnd && switching[j] >= switchStart && switching[j] <= switchEnd) {
          stroke(clusterColor[i], 220);
          strokeWeight(scaleFactor);
          point(width-cPanelWidth+10 + (j%imgWidth)*scaleFactor, 10 + (j/imgWidth)*scaleFactor);
        }
      }
    }
    
    // Top 10 Stable Nodes
    int n = 0;
    for(int j=0; j<count; j++) {
      if(topStable[i] != pixelID[j]) {
        n++;
      }
    }
    if(n == count) {
      topStableButton[i].bLock = false;
    }
    
    // Top 10 Most Connected Nodes
    int m = 0;
    for(int j=0; j<count; j++) {
      if(topDegree[i] != pixelID[j]) {
        m++;
      }
    }
    if(m == count) {
      topDegreeButton[i].bLock = false;
    }
    
    // selected nodes
    if (pixelID[i]>=0) {
      stroke(selectColor2[i]);
      strokeWeight(scaleFactor*3);
      point(width-cPanelWidth+10 + (pixelID[i]%imgWidth)*scaleFactor, 10 + (pixelID[i]/imgWidth)*scaleFactor);
    }
  }
  
  //**************************************** 3D Views control panel ****************************************/ 
  fill(20);
  textSize(14);
  textAlign(LEFT, TOP);
  text("3D Views", width-cPanelWidth+35, imgHeight*scaleFactor+20 + radius*33.2);
  
  stroke(20);
  strokeWeight(1);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*34, width-cPanelWidth+30, imgHeight*scaleFactor+20 + radius*34);
  line(width-cPanelWidth+40+textWidth("3D Views"), imgHeight*scaleFactor+20 + radius*34, width-10, imgHeight*scaleFactor+20 + radius*34);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*34, width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*42.5);
  line(width-10, imgHeight*scaleFactor+20 + radius*34, width-10, imgHeight*scaleFactor+20 + radius*42.5);
  line(width-cPanelWidth+10, imgHeight*scaleFactor+20 + radius*42.5, width-10, imgHeight*scaleFactor+20 + radius*42.5);
  
  //spaceT.draw();
  spaceA.draw();
  
  fill(20);
  textSize(12);
  textAlign(LEFT, TOP);
  text("- Rotation -", width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*36.5);
  text(" X-axis", width-imgWidth*scaleFactor, imgHeight*scaleFactor+20 + radius*38);
  text(" Y-axis", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)/3, imgHeight*scaleFactor+20 + radius*38);
  text(" Z-axis", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)*2/3, imgHeight*scaleFactor+20 + radius*38);
  
  noFill();
  stroke(20);
  strokeWeight(1);
  xRotation[0].draw(width-imgWidth*scaleFactor+textWidth(" X-axis")+radius, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  xRotation[1].draw(width-imgWidth*scaleFactor+textWidth(" X-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  yRotation[0].draw(width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)/3+textWidth(" Y-axis")+radius, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  yRotation[1].draw(width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)/3+textWidth(" Y-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  zRotation[0].draw(width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)*2/3+textWidth(" Z-axis")+radius, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  zRotation[1].draw(width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)*2/3+textWidth(" Z-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.7, radius, radius);
  fill(10);
  textSize(12);
  textAlign(CENTER, CENTER);
  text("-", width-imgWidth*scaleFactor+textWidth(" X-axis")+radius, imgHeight*scaleFactor+20 + radius*38.5);
  text("+", width-imgWidth*scaleFactor+textWidth(" X-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.5);
  text("-", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)/3+textWidth(" Y-axis")+radius, imgHeight*scaleFactor+20 + radius*38.5);
  text("+", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)/3+textWidth(" Y-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.5);
  text("-", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)*2/3+textWidth(" Z-axis")+radius, imgHeight*scaleFactor+20 + radius*38.5);
  text("+", width-imgWidth*scaleFactor+(imgWidth*scaleFactor-20)*2/3+textWidth(" Z-axis")+radius*3, imgHeight*scaleFactor+20 + radius*38.5);
  
  float s = (imgWidth*scaleFactor-20)/2 - radius*6;
  textAlign(CENTER, CENTER);
  text("Play", width-imgWidth*scaleFactor+radius*1.5+s, imgHeight*scaleFactor+20 + radius*40.5);
  text("Pause", width-imgWidth*scaleFactor+radius*6.75+s, imgHeight*scaleFactor+20 + radius*40.5);
  text("Stop", width-imgWidth*scaleFactor+radius*12+s, imgHeight*scaleFactor+20 + radius*40.5);
  
  noFill();
  stroke(20);
  strokeWeight(1);
  play.draw(width-imgWidth*scaleFactor+s, imgHeight*scaleFactor+20 + radius*40, radius*3, radius*3/2);
  pause.draw(width-imgWidth*scaleFactor+radius*5+s, imgHeight*scaleFactor+20 + radius*40, radius*3.5, radius*3/2);
  stop.draw(width-imgWidth*scaleFactor+radius*10.5+s, imgHeight*scaleFactor+20 + radius*40, radius*3, radius*3/2);
  
  // play the animation
  if (play.bLock) {
    play_delta += 0.20;    
    if (floor(play_delta) == 1) {
      if (currentFrame+(int)winSize/2 < frameEnd) {
        currentFrame += 1;
      } else if (currentFrame+(int)winSize/2 == frameEnd) {
        currentFrame = frameStart-(int)winSize/2;
      }     
    }   
    if (play_delta > 1) {
      play_delta = 0;
    }
  }
  
  //**************************************** swords view ****************************************/ 
  // swords view - x: 0~width-imgWidth*scaleFactor-20; y: 0~height 
  /*translate(0, 0, -top);
  int t = 0;
  for(int i=0; i<count && pixelID[i]>=0; i++) { 
    translate(0, 0, i);   
    sword[i].draw(pixelID[i], pValueFile.value, pValueFile.timeline, nDegreeFile.value, nDegreeFile.timeline);
    t++;
  }
  translate(0, 0, top-t+1);*/
  translate(0, 0, -(count+1)*2);
  for(int i=0; i<count; i++) {
    translate(0, 0, 2);   
    sword[i].draw(pixelID[i], pValueFile.value, pValueFile.timeline, nDegreeFile.value, nDegreeFile.timeline);
  }
  
  //**************************************** 3D views ****************************************/ 
  if(spaceT.checked || spaceA.checked) {
    translate(0, 0, 2);
    fill(220);
    stroke(40);
    strokeWeight(1);
    rect(width-cPanelWidth-height*5/6, 0, height*5/6, height);
    //translate(0, 0, -1);
    fill(10);
    textSize(14);
    textAlign(LEFT, TOP);
    text("Current Frame: " + (currentFrame+(int)winSize/2), width-cPanelWidth-height*5/6+10, 10);
    
    float scale = 0.8;
    float xCenter = width-cPanelWidth-height*5/6 + height*15/42;
    float yCenter = height*3/4;
    float zCenter = imgHeight*3/2;
    translate(xCenter, yCenter, zCenter);
    if (rotate) {
      rotateY += rotateRate;      
    }
    rotateX(rotateX); 
    rotateY(rotateY);
    rotateZ(rotateZ);
    
    translate(0, shiftY, 0);
    beginShape();
    texture(img);
    vertex(-imgWidth*scale, 0, -imgHeight*scale, 0, 0);
    vertex(-imgWidth*scale, 0, imgHeight*scale, 0, imgHeight);
    vertex(imgWidth*scale, 0, imgHeight*scale, imgWidth, imgHeight);
    vertex(imgWidth*scale, 0, -imgHeight*scale, imgWidth, 0);
    endShape(CLOSE);
    translate(0, -shiftY, 0);
    
    stroke(20);
    strokeWeight(scaleFactor);
    line(-imgWidth*scale-10*scale, -10*scale, -imgHeight*scale-10*scale, -imgWidth*scale+40*scale, -10*scale, -imgHeight*scale-10*scale);  // x
    line(-imgWidth*scale-10*scale, -10*scale, -imgHeight*scale-10*scale, -imgWidth*scale-10*scale, -10*scale, -imgHeight*scale+40*scale);  // z
    line(-imgWidth*scale-10*scale, -10*scale, -imgHeight*scale-10*scale, -imgWidth*scale-10*scale, -60*scale, -imgHeight*scale-10*scale);  // y
    fill(20);
    textSize(12*scale);
    textAlign(LEFT, CENTER);
    text(" X", -imgWidth*scale+40*scale, -10*scale, -imgHeight*scale-10*scale);
    textAlign(CENTER, CENTER);
    text(" Y", -imgWidth*scale-10*scale, -10*scale, -imgHeight*scale+45*scale);    
    
    // draw nodes in 3D views
    if(spaceA.checked) {  // space-attribute cube
      float y = (yCenter-height/4)/nDegreeMax;
      for(int i=0; i<pixel; i++) {
        float x = int(i%imgWidth);
        float z = int(i/imgWidth);
        if (nDegreeFile.value[currentFrame][i] != 0 && currentFrame < nDegreeFile.timeline
        && nDegreeFile.value[currentFrame][i] >= degreeStart && nDegreeFile.value[currentFrame][i] <= degreeEnd
        && homing[i] >= homingStart && homing[i] <= homingEnd && switching[i] >= switchStart && switching[i] <= switchEnd) {
          strokeWeight(5);
          if(iColorFile.value[currentFrame][i] != 0 && topCommButton[(int)iColorFile.value[currentFrame][i]-1].bLock) {
            stroke(clusterColor[(int)iColorFile.value[currentFrame][i]-1]);
            point((-imgWidth+x*scaleFactor)*scale, nDegreeFile.value[currentFrame][i] * (-y), (-imgHeight+z*scaleFactor)*scale);
          } else if(iColorFile.value[currentFrame][i] == 0) {
            stroke(clusterColor[top]);
            point((-imgWidth+x*scaleFactor)*scale, nDegreeFile.value[currentFrame][i] * (-y), (-imgHeight+z*scaleFactor)*scale);
          }          
        }
      } // for
      fill(20);
      textSize(12*scale);
      textAlign(LEFT, CENTER);
      text("Node Degree", -imgWidth*scale-10*scale, -70*scale, -imgHeight*scale-10*scale);
    } else {  // space-time cube
      float y = (yCenter-height/4)/( min(iColorFile.timeline, frameEnd) - frameStart);
      for(int i=0; i<count; i++) {
        float x = int(pixelID[i]%imgWidth);
        float z = int(pixelID[i]/imgWidth);
        for(int j=frameStart; j<min(iColorFile.timeline, frameEnd); j++) {          
          if(gColorFile.value[j-(int)winSize/2][pixelID[i]] != 0 && j >= (int)winSize/2) {
            //stroke(clusterColor[(int)iColorFile.value[j-(int)winSize/2][pixelID[i]]-1]);
            //strokeWeight(5);
            //point((-imgWidth+x*scaleFactor)*scale, (j-frameStart)*(-y), (-imgHeight+z*scaleFactor)*scale);   
            translate((-imgWidth+x*scaleFactor)*scale, (j-frameStart)*(-y), (-imgHeight+z*scaleFactor)*scale);         
            noStroke();
            if((int)gColorFile.value[j-(int)winSize/2][pixelID[i]] != (int)iColorFile.value[j-(int)winSize/2][pixelID[i]]) {
              fill(clusterColor[(int)gColorFile.value[j-(int)winSize/2][pixelID[i]]-1], 205);
              box(6, 2.5, 6);
            }
            if(iColorFile.value[j-(int)winSize/2][pixelID[i]] != 0) {
              fill(clusterColor[(int)iColorFile.value[j-(int)winSize/2][pixelID[i]]-1], 240);      
            } else {
              fill(clusterColor[top], 240);
            }       
            sphere(2.5);
            translate(-(-imgWidth+x*scaleFactor)*scale, (j-frameStart)*y, -(-imgHeight+z*scaleFactor)*scale);
          } /*else {
            stroke(clusterColor[top]);
            strokeWeight(5);
            point((-imgWidth+x*scaleFactor)*scale, (j-frameStart)*(-y), (-imgHeight+z*scaleFactor)*scale);
          } */        
        }
      }
      fill(20);
      textSize(12*scale);
      textAlign(LEFT, CENTER);
      text("Time", -imgWidth*scale-10*scale, -70*scale, -imgHeight*scale-10*scale);
    } // if-else
    
       
    translate(-xCenter, -yCenter, -zCenter);    
    translate(0, 0, -2);
  }
  } // doneLoading
  else {
    noFill();
    stroke(40);
    strokeWeight(scaleFactor);
    rect(width/4, height/2, width/2, 15, 8);
    
    noStroke();
    fill(45);
    float w = map(loadingPercent, 0, 1, 0, width/2);
    rect(width/4, height/2, w, 15, 8);
    
    fill(10);
    textSize(18);
    textAlign(CENTER, BOTTOM);
    text("Loading Files ... ", width/2, height/2-10);
  }
  //
  save("test.jpg");
}
