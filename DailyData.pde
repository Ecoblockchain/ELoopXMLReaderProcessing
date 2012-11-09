public class DailyData {
  public float min, max, avg;
  public int numberOfValues;
  public String date;

  public DailyData(String _date, float _min, float _max, float _avg, int _nv) {
    date = _date;
    min = _min;
    max = _max;
    avg = _avg;
    numberOfValues = _nv;
  }
}

