/*
This class takes in a 2D array from the CSVFile class and gives use our
data. Since the particular rainfall file does not seperate our months
into seperate columns. We have to do it manually in this file.
*/
public class PrecipController{
  private String[][] data;
  private int[] years;
  private String[] months;
  public PrecipController(String[][] d){
     data = d;
     months = new String[]{"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
     loadYears();
  }
  private void loadYears(){
    int yS = int(data[1][1]);
    int yE = int(data[data.length-1][1]);
    years = new int[(yE - yS)+1];
    for(int i = 0; i <= (yE-yS); i++){
      years[i] = yS + i;
    }
  }
  public int[] years(){
    return years;
  }
  public String[] months(){
    return months;
  }
  public float[] precip(int month){
    if(month < 1 || month > 12)
      return null;
    float[] precip = new float[years().length];
    int ind = 0;
    for(int i = 1; i < data.length; i++){
      if(int(data[i][2]) == month){
        precip[ind++] = float(data[i][0]);
      }
    }
    return precip;
  }
  public float precipMin(){
    float min = Float.MAX_VALUE;
    for(int i = 1; i < data.length; i++){
      float val = float(data[i][0]);
      if(val < min){
        min = val;
      }
    }
    return min;
  }
  public float precipMax(){
    float max = Float.MIN_VALUE;
    for(int i = 1; i < data.length; i++){
      float val = float(data[i][0]);
      if(val > max){
        max = val;
      }
    }
    return max;
  }
}