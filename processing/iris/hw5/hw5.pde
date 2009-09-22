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
int[] Colors = {#FF7C7C, #7D7CFF, #7CFFC7, #FCFF7C};

Statistics stat;

// Ploting variables
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
PFont plotFont;

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
//  println();
//  println(class_mean(Data,Sepal_Length,"Iris"));
//  println(class_sd(Data,Sepal_Length,"Iris"));
//  println(class_mean(Data,Sepal_Width,"Iris"));
//  println(class_sd(Data,Sepal_Width,"Iris"));
}

void draw() {
  background(255);
  
  drawTitle();
  drawAxisLabels();
//  drawVolumeLabels();

  noStroke();
  //fill(#5679C1);
  drawDataBars();
  
//  drawYearLabels();

}

void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  String title = "Mean value of the attributes";
  text(title, plotX1, plotY1 - 10);
}

void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Length (cm)", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Class", (plotX1+plotX2)/2, labelY);
}

float barWidth = 20;  // Add this line above setup()

void drawDataBars() {
  noStroke();
  rectMode(CORNERS);
  //stat.get("Iris-setosa", "sepal_length", "mean");  
  for (int i = 0; i < Attr.length; i++) {
    for(int j= 0; j < Names.length; j++) {
      fill(Colors[j]);
      float value = stat.get(Names[j], Attr[i], "mean");
      int idx = j + i * Names.length;
      float x = map(idx, 0, Names.length*Attr.length, plotX1, plotX2);
      float y = map(value, 0, 10, plotY2, plotY1);
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
}

float class_mean(FloatTable table, int col, String class_name) {
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

float class_sd(FloatTable table, int col, String class_name) {
  int n_row =  table.getRowCount();
  int n = 0;
  float sum=0;
  float mean = class_mean(table, col, class_name);
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
    setosa.put("sd", compute_mean(data, "Iris-setosa"));
    versicolor.put("sd", compute_mean(data, "Iris-versicolor"));
    virginica.put("sd", compute_mean(data, "Iris-virginica"));
    iris.put("sd", compute_mean(data, "Iris"));    
    Attributes iris_mean = (Attributes) iris.get("mean");
    println(iris_mean.sepal_length);
    println(getField(iris_mean, "sepal_length"));
  }
  
  Attributes compute_mean(FloatTable data, String name) {
    Attributes attr = new Attributes();
    attr.sepal_length = class_mean(data, Sepal_Length, name);
    attr.sepal_width = class_mean(data, Sepal_Width, name);
    attr.petal_length = class_mean(data, Petal_Length, name);
    attr.petal_width = class_mean(data, Petal_Width, name);
    
    return attr;
  }
  
  Attributes compute_sd(FloatTable data, String name) {
    Attributes attr = new Attributes();
    attr.sepal_length = class_sd(data, Sepal_Length, name);
    attr.sepal_width = class_sd(data, Sepal_Width, name);
    attr.sepal_length = class_sd(data, Petal_Length, name);
    attr.petal_width = class_sd(data, Petal_Width, name);
    
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

