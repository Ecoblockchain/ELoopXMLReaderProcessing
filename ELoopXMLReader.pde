/**
 * Loading XML Data
 * 
 * Here is what the XML looks like:
 *
 * <data id="n">
 <tag>name</tag>
 <current_value at="date&time">value</current_value>
 </data>
 */


void setup() {
  size(640, 360);
  smooth();

  XML xml = loadXML("data.xml");
  SensorData waterData = new SensorData("water", xml);
  waterData.printInfo();
  ArrayList<PVector> waterDailyValues = waterData.getDailyValues();
}


void draw() {
  //background(255);
}

