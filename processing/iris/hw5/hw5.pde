FloatTable Data;

int Sepal_Length = 0;
int Sepal_Width = 1;
int Petal_Length = 2;
int Petal_Width = 3;

void setup() {
  Data = new FloatTable("iris.tsv");
  /*println(Data.getColumnMax(0));
  println(Data.getColumnMax(1));
  println(Data.getColumnMax(2));
  println(Data.getColumnMax(3));
  println(total_mean(Data, Sepal_Length));
  println(total_mean(Data, Sepal_Width));
  println(total_mean(Data, Petal_Length));
  println(total_mean(Data, Petal_Width));
  println(class_mean(Data, Sepal_Length, "Iris-setosa"));
  println(class_mean(Data, Sepal_Length, "Iris-versicolor"));
  println(class_mean(Data, Sepal_Length, "Iris-virginica"));
  println(total_sd(Data, Sepal_Length));
  println(total_sd(Data, Sepal_Width));*/
  println(class_sd(Data, Sepal_Length, "Iris-setosa"));
  println(class_sd(Data, Sepal_Length, "Iris-versicolor"));
  println(class_sd(Data, Sepal_Length, "Iris-virginica"));
}

void draw() {
}

float total_mean(FloatTable table, int col) {
  int n =  table.getRowCount();
  float sum = 0;
  for(int i=0; i < n; i++) {
    sum += table.getFloat(i, col);
  }
  return sum / n ;
}

float total_sd(FloatTable table, int col) {
  int n = table.getRowCount();
  float mean = total_mean(table, col);
  float sum = 0;
  for(int i=0; i < n; i++) {
    sum += pow((table.getFloat(i, col) - mean), 2);
  }
  return sqrt(sum/n);
}

float class_mean(FloatTable table, int col, String class_name) {
  int n_row =  table.getRowCount();
  int n = 0;
  float sum=0;
  for(int i=0; i < n_row; i++) {
    String name = table.getRowName(i);
    if (name.equals(class_name)) {
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
    if (name.equals(class_name)) {
      sum += pow((table.getFloat(i, col) - mean), 2);
      n++;
    }
  }
  return sqrt(sum / (n-1));
}
