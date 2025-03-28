import processing.serial.*;

Serial myPort;
float ballX, ballY;
int sensorValue;
String[] portList;

void setup() {
  size(800, 800);
  
  // Get the list of available COM ports
  portList = Serial.list();
  
  // Print available ports in the console
  println("Available COM Ports:");
  for (int i = 0; i < portList.length; i++) {
    println(i + ": " + portList[i]);
  }
  
  // Use the third available port if possible
  if (portList.length > 2) {
    myPort = new Serial(this, "COM8", 115200); // Change the COM Port
    myPort.bufferUntil('\n');


  textFont(createFont("Arial", 24, true)); // Increased text size
}}

void draw() {
  drawBackgroundGradient();
  
  // Draw center cross lines with transparency
  stroke(255, 100);
  strokeWeight(1.5);
  line(width / 2, 0, width / 2, height);
  line(0, height / 2, width, height / 2);
  
  // Map values from -10 to 10 into screen size
  float mappedX = map(-ballY, -10, 10, 50, width - 50);
  float mappedY = map(ballX, -10, 10, 50, height - 50);
  
  // Set ball color based on sensorValue
  color ballColor = (sensorValue == 1) ? color(0, 255, 0) : color(255, 0, 0);
  
  // Draw the glowing effect
  noStroke();
  fill(ballColor, 100); // Semi-transparent glow
  ellipse(mappedX, mappedY, 80, 80); // Increased glow size
  
  // Draw the main ball
  stroke(255);
  strokeWeight(2);
  fill(ballColor);
  ellipse(mappedX, mappedY, 60, 60); // Increased ball size
  
  // Draw sensor value text in the center of the ball
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24); // Increased text size
  text(sensorValue, mappedX, mappedY);
  
  // Display received values on screen
  displayInfo();
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    String[] values = split(data, ',');
    if (values.length == 3) {
      ballX = float(values[0]);
      ballY = float(values[1]);
      sensorValue = int(values[2]);
    }
  }
}

// Function to create a modern gradient background
void drawBackgroundGradient() {
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(30, 30, 30), color(10, 10, 10), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

// Function to display information in a modern format
void displayInfo() {
  fill(255);
  textAlign(LEFT, TOP);
  textSize(20); // Increased text size
  text("X: " + nf(ballX, 1, 2), 20, 20);
  text("Y: " + nf(ballY, 1, 2), 20, 50);
  text("Sensor: " + sensorValue, 20, 80);
  
 
}
