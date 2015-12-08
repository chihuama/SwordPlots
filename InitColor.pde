// initialize top 10 colors

public int top = 10;
public color[] clusterColor;
public color[] degreeColor;
public color[] stableColor;
public color[] selectColor;
public color[] selectColor2;

void InitColor() {
  clusterColor = new color[top+1];
  clusterColor[0] = color(227, 26, 28);
  clusterColor[1] = color(31, 120, 180);
  clusterColor[2] = color(51, 160, 44);
  clusterColor[3] = color(106, 61, 154);
  clusterColor[4] = color(255, 127, 0);
  clusterColor[5] = color(251, 154, 153);
  clusterColor[6] = color(166, 206, 227);
  clusterColor[7] = color(178, 223, 138);
  clusterColor[8] = color(202, 178, 214);
  clusterColor[9] = color(253, 191, 111);
  clusterColor[10] = color(153, 153, 153);
  
  degreeColor = new color[top];
  degreeColor[0] = color(128, 0, 38);
  degreeColor[1] = color(189, 0, 38);
  degreeColor[2] = color(227, 26, 28);
  degreeColor[3] = color(252, 78, 42);
  degreeColor[4] = color(253, 141, 60);
  degreeColor[5] = color(254, 178, 76);
  degreeColor[6] = color(254, 217, 118);
  degreeColor[7] = color(255, 237, 160);
  degreeColor[8] = color(255, 255, 204);
  degreeColor[9] = color(255, 255, 250);
  
  stableColor = new color[top];
  stableColor[0] = color(8, 29, 88);
  stableColor[1] = color(37, 52, 148);
  stableColor[2] = color(34, 94, 168);
  stableColor[3] = color(29, 145, 192);
  stableColor[4] = color(65, 182, 196);
  stableColor[5] = color(127, 205, 187);
  stableColor[6] = color(199, 233, 180);
  stableColor[7] = color(237, 248, 177);
  stableColor[8] = color(255, 255, 217);
  stableColor[9] = color(255, 255, 250);
  
  selectColor = new color[top];
  selectColor[0] = color(103, 0, 31);
  selectColor[1] = color(152, 0, 67);
  selectColor[2] = color(206, 18, 86);
  selectColor[3] = color(231, 41, 138);
  selectColor[4] = color(223, 101, 176);
  selectColor[5] = color(201, 148, 199);
  selectColor[6] = color(212, 185, 218);
  selectColor[7] = color(231, 225, 239);
  selectColor[8] = color(247, 244, 249);
  selectColor[9] = color(255, 255, 250);
  
  selectColor2 = new color[top];
  for(int i=0; i<top; i++) {
    selectColor2[i] = selectColor[i];
  }
}
