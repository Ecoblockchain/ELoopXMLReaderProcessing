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


HashMap<String, ArrayList<Float> > theValues;

void setup() {
  size(640, 360);
  smooth();
  theValues = new HashMap<String, ArrayList<Float> >();

  readData();
  normalizeData();
  displayData();

}

void readData() {
  // Load an XML document
  XML xml = loadXML("data.xml");

  // Get all the data elements
  XML[] children = xml.getChildren("data");

  // parse data elements and get tag and current_value
  for (int i = 0; i < children.length; i ++ ) {
    XML nameElement = children[i].getChild("tag");
    String name = nameElement.getContent();

    if (!theValues.containsKey(name)) {
      theValues.put(name, new ArrayList<Float>());
    }

    XML valueElement = children[i].getChild("current_value");
    float v = float(valueElement.getContent());

    theValues.get(name).add(new Float(v));
  }
}

// this could be smarter.
//   right now it goes through the arrays twice.
void normalizeData() {
  Iterator it = theValues.keySet().iterator();
  while (it.hasNext ()) {
    String sName = (String)it.next();
    float maxV, minV; 

    ArrayList<Float> t = theValues.get(sName);

    // get max and min values
    maxV = t.get(0).floatValue();
    minV = t.get(0).floatValue();
    for (int i=0; i<t.size(); i++) {
      if (t.get(i).floatValue() < minV) {
        minV = t.get(i).floatValue();
      }
      if (t.get(i).floatValue() > maxV) {
        maxV = t.get(i).floatValue();
      }
    }

    // have max and min. scale
    for (int i=0; i<t.size(); i++) {
      Float nF = new Float(map(t.get(i), minV, maxV, 0, 1));
      println(nF);
      t.set(i, nF);
    }
  }
}

void displayData() {
  background(255);
  Iterator it = theValues.keySet().iterator();
  while (it.hasNext ()) {
    String sName = (String)it.next();

    ArrayList<Float> t = theValues.get(sName);
    stroke(random(100, 190), random(100, 190), random(100, 190));
    strokeWeight(2);

    float lv = t.get(0).floatValue();

    for (int i=1; i<t.size(); i++) {
      float tv = t.get(i).floatValue();
      line((float)(i-1)/t.size()*width, map(lv, 0, 1, height, 0), (float)i/t.size()*width, map(tv, 0, 1, height, 0));
      lv = tv;
    }
  }
}

void draw() {
  //background(255);
}

