/*
Base processing file.
*/
int plotX, plotY, plotH, plotW;
CSVFile file;
PrecipController ctrl;
float dMin, dMax;
int volumeIntervalMinor, volumeInterval, yearInterval,curMonth,columnCount;
// Tab variables for the menus
float[] tabLeft, tabRight; // Add above setup() 
float tabTop, tabBottom, tabPad,labelX, labelY;
void setup(){
  size(1024,720);
  plotX = 200;
  plotY = 100;
  plotW = 724;
  plotH = 520;
  labelX = 100;
  labelY = height - 50;
  
  tabPad = 10;
  
  volumeIntervalMinor = 1;
  volumeInterval = 10;
  yearInterval = 10;
  curMonth = 1;
  file = new CSVFile("data/pr_1991_2015.csv");
  ctrl = new PrecipController(file.getData());
  dMin = ctrl.precipMin();
  dMin = 0;
  dMax = ctrl.precipMax();
  columnCount = ctrl.months().length;
}

void draw(){
  background(255);
  drawVisualizationWindow();
  drawXTickMarks();
  drawYTickMarks();
  drawVolumeData();
  drawTitleTabs();
  drawGraphLabels();
}




void drawTitleTabs(){
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  if(tabLeft == null){
     tabLeft = new float[columnCount];
     tabRight = new float[columnCount];
  }
  float runningX = plotX;
  tabTop = plotY - textAscent()-15;
  tabBottom = plotY;
  for(int col = 0; col < columnCount; col++){
    String title = ctrl.months()[col];
    tabLeft[col] = runningX;
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    fill(col == (curMonth-1) ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    fill(col == (curMonth-1) ? 0 : 64);
    text(title, runningX + tabPad, plotY - 10);
    runningX = tabRight[col];
   }
}

void drawVolumeData(){
  float[] precips = ctrl.precip(curMonth);
  int[] years = ctrl.years();
  if (precips.length != years.length)
    return;
  beginShape();
  for(int i = 0; i < ctrl.years().length; i++){
    float x = map(years[i], years[0], years[years.length-1], plotX, plotX+plotW);
    float y = map(precips[i], dMin, dMax, plotY+plotH, plotY);
    vertex(x,y);
  }
  vertex(plotX+plotW, plotY+plotH);
  vertex(plotX, plotY+plotH);
  endShape(CLOSE);
}
void drawYTickMarks() {
  fill(0);
  textSize(10);

  stroke(128);
  strokeWeight(1);

  for (int v = ceil(dMin); v <= floor(dMax); v++) { 
    if (v % volumeIntervalMinor == 0) { // If a tick mark
      float y = map(v, dMin, dMax, plotY + plotH, plotY);
      if (v % volumeInterval == 0) { // If a major tick mark
        if (v == dMin) {
          textAlign(RIGHT); // Align by the bottom
        } else if (v == dMax) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        text(floor(v), plotX - 10, y);
        line(plotX - 4, y, plotX, y); // Draw major tick
      } else {
        line(plotX - 2, y, plotX, y); // Draw minor tick
      }
    }
  }  
  
}
void drawXTickMarks(){
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);

  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(2);

  for(int y : ctrl.years()){
    float x = map(y, ctrl.years()[0], ctrl.years()[ctrl.years().length-1], plotX, plotX+plotW);
    text(y, x, plotY+plotH + 10);
    line(x, plotY, x, plotY+plotH);
  }
}

void mousePressed(){
   if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setColumn(col);
      }
    }
   }
}
void setColumn(int col) {
   if (col+1 != curMonth) {
     curMonth = col+1;
      System.out.println(curMonth);
   }  
}
void drawVisualizationWindow() {
  fill(255);
  rectMode(CORNERS);
  rect(plotX, plotY, plotX + plotW, plotY + plotH);
}

void drawGraphLabels() {
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("Year", (plotX+(plotX+plotW))/2, labelY);  
  text("Rainfall\n(mm)", labelX, (plotY+(plotY+plotH))/2);
  
}