/*
This class takes any csv file and returns a 2D array of strings.
*/
public class CSVFile{
   private String[][] data;
   public CSVFile(String filename){
     data = null;
     loadCsv(filename);
   }
   
   private void loadCsv(String filename){
     String[] rows = loadStrings(filename);
     data = new String[rows.length][6];
     for(int i = 0; i < rows.length; i++){
        data[i] = split(rows[i],',');
     }
   }
   
   public String[][] getData(){
     return data; 
   }
}