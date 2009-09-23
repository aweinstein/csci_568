/***************************************************************
hw5.pde
CSCI568 Homework 5 
by Alejandro Weinstein
20090922

Note: Some part of the code is based in the code from the book
Visualizing Data, by Ben Fry
****************************************************************/

import java.lang.*;
import java.lang.reflect.*; 

FloatTable Data;

// Index of the attributes
int Sepal_Length = 0;
int Sepal_Width = 1;
int Petal_Length = 2;
int Petal_Width = 3;

String[] Names = {"Iris-setosa", "Iris-versicolor", "Iris-virginica", "Iris"};
String[] Attr  = {"sepal_length", "sepal_width", "petal_length", "petal_width"};
int[] Colors = {#FF7C7C, #7D7CFF, #7CFFC7, #F2E662};

Statistics stat;

// Ploting variables
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
PFont plotFont;

// Tab variables
float[] tabLeft, tabRight;  // Add above setup()
float tabTop, tabBottom;
float tabPad = 10;
int currentColumn = 0;
int columnCount = 3;

void setup() {
  Data = new FloatTable("iris.tsv");
  stat = new Statistics();
  stat.compute(Data);
  
  size(720, 405);
  // Corners of the plotted time series
  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  
  float plotW = plotX2 - plotX1;
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);

  smooth();
}

void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);
  drawXYLabels();
  drawLegend();
  drawTitleTabs();
  drawAxisLabels();

  noStroke();
  if (currentColumn <= 1) {
    drawDataBars();
  } else {
    drawScatter();
  }
}

void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
          currentColumn = col;
      }
    }
  }
}

void drawXYLabels() {
  fill(0);
  textSize(10);
  //textAlign(CENTER, TOP);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  if (currentColumn <=1) {
    textAlign(CENTER, TOP);
    text("Sepal length", plotX1 + 60, plotY2 + 10);
    text("Sepal width", plotX1 + 190, plotY2 + 10);
    text("Petal length", plotX1 + 320, plotY2 + 10);
    text("Petal width", plotX1 + 450, plotY2 + 10);
    float maxY = (currentColumn == 0) ? 10 : 2;
    textAlign(CENTER, CENTER);
    for (int i = 0; i < 5; i++) {
      float yval = (maxY/4)*i;
      float y = map(yval, 0, maxY, plotY2, plotY1);
      text(nf(yval,1,1), plotX1 - 12,  y);
      line(plotX1, y, plotX2, y);
    }
  } else { // Scatter plot
    textAlign(CENTER, TOP);
    for (int xval = 0; xval <= 7; xval++) {
      float x = map(xval, 0, 7, plotX1, plotX2);
      text(xval, x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
    textAlign(CENTER, CENTER);
    for (int yval = 0; yval <= 3; yval++) {
      float y = map(yval, 0, 3, plotY2, plotY1);
      text(yval, plotX1 - 10,  y);
      line(plotX1, y, plotX2, y);
    }
  }
}

void drawLegend() {
  rectMode(CENTER);
  textSize(10);
  textAlign(LEFT);
  noStroke();
  fill(Colors[0]);
  rect(plotX1+20, plotY1+15,10,10);
  fill(0);
  text("Setosa", plotX1+27, plotY1+18);

  fill(Colors[1]);
  rect(plotX1+20, plotY1+30,10,10);
  fill(0);
  text("Versicolor", plotX1+27, plotY1+18+15);

  fill(Colors[2]);
  rect(plotX1+20, plotY1+45,10,10);
  fill(0);
  text("Virginica", plotX1+27, plotY1+18+30);

  if (currentColumn <=1) {
    fill(Colors[3]);
    rect(plotX1+20, plotY1+60,10,10);
    fill(0);
    text("All", plotX1+27, plotY1+18+45);
  }
}

void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  
  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  
  float runningX = plotX1; 
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;
  
  String[] labels = {"Means", "SDs", "Scatter"};
  for (int col = 0; col < columnCount; col++) {
    String title = labels[col];
    tabLeft[col] = runningX; 
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    
    // If the current tab, set its background white, otherwise use pale gray
    fill(col == currentColumn ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    
    // If the current tab, use black for the text, otherwise use dark gray
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    
    runningX = tabRight[col];
  }
}

void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  String xlabel = "";
  String ylabel = "";

  if (currentColumn == 0) {
    xlabel = "Features";
    ylabel = "Mean (cm)";
  } else if (currentColumn == 1) {
    xlabel = "Features";
    ylabel = "Standard \nDeviation (cm)";
  } else {
    xlabel = "Petal length (cm)";
    ylabel = "Petal \nwidth (cm)";
  }  
  textAlign(CENTER, CENTER);
  text(ylabel, labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text(xlabel, (plotX1+plotX2)/2, labelY);
}

float barWidth = 20;  // Add this line above setup()

void drawDataBars() {
  noStroke();
  rectMode(CORNERS);
  String ind = "";
  float maxY = 0;
  if (currentColumn == 0) {
    ind = "mean";
    maxY = 10;
  } else {
    ind = "sd";
    maxY = 2;
  }
  
  for (int i = 0; i < Attr.length; i++) {
    for(int j= 0; j < Names.length; j++) {
      fill(Colors[j]);
      float value = stat.get(Names[j], Attr[i], ind);
      int idx = j + i * Names.length;
      float x = map(idx, 0, Names.length*Attr.length, plotX1, plotX2);
      float y = map(value, 0, maxY, plotY2, plotY1);
      rect(x-barWidth/2+15, y, x+barWidth/2+15, plotY2);
    }
  }
}

void drawScatter() {
  strokeWeight(5); 
  for(int i=0; i < Data.getRowCount(); i++) {
    String name = Data.getRowName(i);
    if (name.equals("Iris-setosa")) {
      stroke(Colors[0]);
    } else if (name.equals("Iris-versicolor")) {
      stroke(Colors[1]);
    } else if (name.equals("Iris-virginica")) {
      stroke(Colors[2]);
    } else {
      println("Something wrong happens!");
    }
    float val_x = Data.getFloat(i, Petal_Length);
    float val_y = Data.getFloat(i, Petal_Width);
    float x = map(val_x, 0, 7, plotX1, plotX2);
    float y = map(val_y, 0, 3, plotY2, plotY1);
    point(x,y);
  }
}

float mean(FloatTable table, int col, String class_name) {
  int n_row =  table.getRowCount();
  int n = 0;
  float sum=0;
  for(int i=0; i < n_row; i++) {
    String name = table.getRowName(i);
    if (name.equals(class_name) | class_name.equals("Iris")) {
      sum += table.getFloat(i, col);
      n++;
    }
  }
  return sum / n ;
}

float sd(FloatTable table, int col, String class_name) {
  int n_row =  table.getRowCount();
  int n = 0;
  float sum=0;
  float mean = mean(table, col, class_name);
  for(int i=0; i < n_row; i++) {
    String name = table.getRowName(i);
    if (name.equals(class_name) | class_name.equals("Iris")) {
      sum += pow((table.getFloat(i, col) - mean), 2);
      n++;
    }
  }
  return sqrt(sum / (n-1));
}


class Attributes {
  public float sepal_length;
  public float sepal_width;
  public float petal_length;
  public float petal_width;

  Attributes() {
    sepal_length = 0;//new Float(0);
    sepal_width = 0;//new Float(0);
    petal_length = 0;// new Float(0);
    petal_width = 0;//new Float(0);
  }
}

class Statistics {
  HashMap setosa;
  HashMap versicolor;
  HashMap virginica;
  HashMap iris;  
  
  Statistics() {
    setosa = new HashMap();
    versicolor = new HashMap();
    virginica = new HashMap();
    iris = new HashMap();
  }
  
  void compute(FloatTable data) {
    println("Computing the stats...");
    setosa.put("mean", compute_mean(data, "Iris-setosa"));
    versicolor.put("mean", compute_mean(data, "Iris-versicolor"));
    virginica.put("mean", compute_mean(data, "Iris-virginica"));
    iris.put("mean", compute_mean(data, "Iris"));
    setosa.put("sd", compute_sd(data, "Iris-setosa"));
    versicolor.put("sd", compute_sd(data, "Iris-versicolor"));
    virginica.put("sd", compute_sd(data, "Iris-virginica"));
    iris.put("sd", compute_sd(data, "Iris"));    
  }
  
  Attributes compute_mean(FloatTable data, String name) {
    Attributes attr = new Attributes();
    attr.sepal_length = mean(data, Sepal_Length, name);
    attr.sepal_width = mean(data, Sepal_Width, name);
    attr.petal_length = mean(data, Petal_Length, name);
    attr.petal_width = mean(data, Petal_Width, name);
    
    return attr;
  }
  
  Attributes compute_sd(FloatTable data, String name) {
    Attributes attr = new Attributes();
    attr.sepal_length = sd(data, Sepal_Length, name);
    attr.sepal_width = sd(data, Sepal_Width, name);
    attr.petal_length = sd(data, Petal_Length, name);
    attr.petal_width = sd(data, Petal_Width, name);
    
    return attr;
  }

  float get(String s, String attr, String stat) {
    Attributes data = new Attributes();
    if(s.equals("Iris-setosa")) {
      data = (Attributes) setosa.get(stat);
    } else if (s.equals("Iris-versicolor")) {
      data = (Attributes) versicolor.get(stat);
    } else if (s.equals("Iris-virginica")) {
      data = (Attributes) virginica.get(stat);
    } else if (s.equals("Iris")) {
      data = (Attributes) iris.get(stat);
    }
    return getField(data, attr);
  }
}

// See http://processing.org/discourse/yabb2/YaBB.pl?num=1205166667/3
// Why everything is so complicated in Java?
public static float getField(Object o, String fieldName){
  Field anyField;
  float f = 0.0;
  Class theClass=o.getClass();
    try{
	anyField = theClass.getField(fieldName); //We hope
        f = anyField.getFloat(o);
    }
    catch (Exception e){
	e.printStackTrace();
    }
  return f;
}

