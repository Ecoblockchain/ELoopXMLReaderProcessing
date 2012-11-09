public class SensorData {
  private String sensorName;
  private ArrayList<Float> theValues;
  private ArrayList<String> theDateAndTime;

  private ArrayList<DailyData> theDailyData;

  private float theMin, theMax;

  public SensorData(String _name, XML _xml) {
    theValues = new ArrayList<Float>();
    theDateAndTime = new ArrayList<String>();

    theDailyData = new ArrayList<DailyData>();

    theMin = MAX_FLOAT;
    theMax = -MAX_FLOAT;

    sensorName = _name;

    parseData(_name, _xml);
  }

  private void parseData(String _name, XML _xml) {
    // Get all the data elements
    XML[] children = _xml.getChildren("data");

    String lastDate = "";
    ArrayList<Float> tempDaily = new ArrayList<Float>();

    // parse data elements and get date and current_value for this tag/name/sensor
    for (int i = 0; i < children.length; i ++ ) {
      XML nameElement = children[i].getChild("tag");
      String name = nameElement.getContent();

      if (name.equals(_name)) {
        XML valueElement = children[i].getChild("current_value");
        float v = float(valueElement.getContent());
        String d = valueElement.getString("at");

        // add to raw array
        theValues.add(new Float(v));
        theDateAndTime.add(d);

        // min/max
        if (v<theMin) { 
          theMin = v;
        }
        if (v>theMax) { 
          theMax = v;
        }

        // ggrrrrrr!!!
        String date = (d.indexOf("T")>-1)?(d.substring(0, d.indexOf("T"))):("");
        // new day! calculate stuff!
        if (lastDate.equals(date) == false) {
          float tmin = MAX_FLOAT;
          float tmax = -MAX_FLOAT;
          float tsum = 0;

          for (int ii=0; ii<tempDaily.size(); ii++) {
            if (tempDaily.get(ii)<tmin) { 
              tmin = tempDaily.get(ii);
            }
            if (tempDaily.get(ii)>tmax) { 
              tmax = tempDaily.get(ii);
            }
            tsum += tempDaily.get(ii);
          }

          if ((tempDaily.size()>0) && (!lastDate.equals(""))) {
            theDailyData.add(new DailyData(lastDate, tmin, tmax, tsum/tempDaily.size(), tempDaily.size()));
          }
          tempDaily.clear();
        }
        // add to day array
        lastDate = date;
        tempDaily.add(new Float(v));
      }
    }

    // last day of data is still in the array when we get here
    if ((tempDaily.size()>0) && (!lastDate.equals(""))) {
      float tmin = MAX_FLOAT;
      float tmax = -MAX_FLOAT;
      float tsum = 0;

      for (int ii=0; ii<tempDaily.size(); ii++) {
        if (tempDaily.get(ii)<tmin) { 
          tmin = tempDaily.get(ii);
        }
        if (tempDaily.get(ii)>tmax) { 
          tmax = tempDaily.get(ii);
        }
        tsum += tempDaily.get(ii);
      }

      theDailyData.add(new DailyData(lastDate, tmin, tmax, tsum/tempDaily.size(), tempDaily.size()));
    }
    tempDaily.clear();
  }

  public void printInfo() {
    println("My name is "+sensorName);

    println("I got "+theValues.size()+" raw sensor values");
    println("My min is: "+theMin+", my max: "+theMax);

    println("---daily min,max,avg---");
    for (int i=0; i<theDailyData.size(); i++) {
      println("sensorName["+theDailyData.get(i).date+"]: "+
        theDailyData.get(i).min+" "+
        theDailyData.get(i).max+" "+
        theDailyData.get(i).avg);
    }
  }

  public ArrayList<DailyData> getDailyData() {
    return theDailyData;
  }
}

