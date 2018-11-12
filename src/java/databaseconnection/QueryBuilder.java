/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package databaseconnection;

/**
 *
 * @author aurea
 */
public class QueryBuilder {

    public static String getListAttributeCategoriesQuery(String attributeTableName, String attributeCategoryName) {
        String query = "SELECT " + attributeCategoryName + " from " + attributeTableName
                + " group by " + attributeCategoryName + " order by " + attributeCategoryName + " ;";
        return query;
    }

    public static String getAttributesByCategory(String attributeTableName, String attributeNameName, String attributeCategoryName, String attributeCategoryValue) {
        String query = "SELECT " + attributeNameName + " from " + attributeTableName
                + " where " + attributeCategoryName + "= '" + attributeCategoryValue + "' order by " + attributeNameName + " ;";
        return query;

    }

    public static String getMaxTime(String instanceTableName, String instanceUTCTimeName) {
        String query = "SELECT max(" + instanceUTCTimeName + ") as max_time_utc from " + instanceTableName+ " ;";
        return query;
    }

    public static String getMinTime(String instanceTableName, String instanceUTCTimeName) {
        String query = "SELECT min(" + instanceUTCTimeName + ") as min_time_utc from " + instanceTableName+ " ;";
        return query;
    }

    public static String getListSource1(String source1TableName, String source1IdName, String source1NameName) {
        String query = "SELECT " + source1NameName + ", " + source1IdName + " from " + source1TableName + " order by " + source1IdName+ " ;";
        return query;
    }
    
     public static String getListSource1Category(String source1TableName,  String source1CategoryName) {
        String query = "SELECT " + source1CategoryName +" from " + source1TableName + " group by " +source1CategoryName+
                " order by "+source1CategoryName+" ;";
        return query;
    }
    public static String getListSource1ByCategory(String source1TableName, String source1IdName, String source1NameName, String source1CategoryName,
            String source1CategoryValue) {
        String query = "SELECT " + source1NameName + ", " + source1IdName + " from " + source1TableName + " where "+source1CategoryName+
                "='"+source1CategoryValue+"' order by " + source1IdName+ " ;";
        return query;
    }

    public static String getListSource2(String source2TableName, String source2IdName, String source2NameName) {
        String query = "SELECT " + source2NameName + ", " + source2IdName + " from " + source2TableName + " order by " + source2IdName+ " ;";
        return query;
    }

    public static String getDataByAggregationFunction(String functionName,
            String stringAttributes, String source2, String source1,
            String fromDateStr, String toDateStr,   long valueUnitIntervalinSecs) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "]," + source2 + "," + source1
                    + ", '" + fromDateStr + "', '" + toDateStr + "',"  +valueUnitIntervalinSecs
                    + ");";
        } else {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "]," + source1
                    + ", '" + fromDateStr + "', '" + toDateStr + "'," + valueUnitIntervalinSecs
                    + ");";
        }
        return query;
    }

    public static String getDataByAggregationFunctionAndThreshold(String functionName,
            String stringAttributes, String source2, String source1,
            String fromDateStr, String toDateStr, long valueUnitIntervalinSecs, String valueThreshold) {
        
        String query = "";
        if (source2 != null && !source2.equals("")) {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "]," + source2 + "," + source1
                    + ", '" + fromDateStr + "', '" + toDateStr + "'," + valueUnitIntervalinSecs + ", " + valueThreshold
                    + ");";
        } else {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "]," + source1
                    + ", '" + fromDateStr + "', '" + toDateStr + "'," + valueUnitIntervalinSecs + ", " + valueThreshold
                    + ");";
        }

        return query;
    }

    public static String getDataByAggregationFunctionForAllSource1(String functionName,
            String stringAttributes, String source2,
            String fromDateStr, String toDateStr, Integer initTime, Integer endTime,String unitTime,
            long valueUnitIntervalinSecs) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "]," + source2 + ", '" + fromDateStr + "', '" + toDateStr + "'," +
                    initTime + ", " + endTime + ",'" +
                    unitTime+"'," + valueUnitIntervalinSecs
                    + ");";
        } else {
            query = "select * from " + functionName + "(ARRAY["
                    + stringAttributes + "], '" + fromDateStr + "', '" + toDateStr + "'," + initTime + ", " + 
                    endTime  + ",'" +
                    unitTime+"'," + valueUnitIntervalinSecs
                    + ");";
        }

        return query;
    }

    public static String getDataByAggregationFunctionAndThresholdForAllSource1(String functionName,
            String stringAttributes, String source2,
            String fromDateStr, String toDateStr, long valueUnitIntervalinSecs, String valueThreshold) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "]," + source2
                + ", '" + fromDateStr + "', '" + toDateStr + "',"  + valueUnitIntervalinSecs + ", " + valueThreshold
                + ");";}
        else{
             query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "], '" + fromDateStr + "', '" + toDateStr + "'," + valueUnitIntervalinSecs + ", " + valueThreshold
                + ");";
        }
        return query;
    }
    
    
     public static String getNameSource1ByIdNameSource(String tableNameSource1, String nameSource1, String idSource1, String valueIdSource1){
           String query = "select "+nameSource1+" from "+tableNameSource1+" where "+idSource1+"="+valueIdSource1+ " ;";
           return query;
     }
     
      public static String getNameAndCategorySource1ByIdNameSource(String tableNameSource1,String nameSource1, String categorySource1, String idSource1, String valueIdSource1){
           String query = "select "+nameSource1+", "+categorySource1+" from "+tableNameSource1+" where "+idSource1+"="+valueIdSource1+ " ;";
           return query;
     }
     
        public static String getIdNameSource1ByNameSource(String tableNameSource1, String nameSource1, String idSource1, String valueNameSource1){
           String query = "select "+idSource1+" from "+tableNameSource1+" where "+nameSource1+"= '"+valueNameSource1+ "' ;";
           return query;
     }
     
        
     public static String getMaxAndMinValueClassificationByIntervalDates(String functionName,
            String stringAttributes, String attributeTarget, String source2, String source1, 
            String fromDateStr, String toDateStr, String valueThreshold) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ "," + source1 + ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ "," + source1 + ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        else{
             if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', " + source1 + ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', " + source1 + ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        return query;
    }

     
     public static String getMaxAndMinValueClassificationByIntervalDatesForAllSource1(String functionName,
            String stringAttributes, String attributeTarget, String source2, String fromDateStr, String toDateStr, String valueThreshold) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        else{
             if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',  '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        return query;
    }

    
     
     
     public static String getDataByIntervalDates(String functionName,
            String stringAttributes, String attributeTarget, String source2, String source1, 
            String fromDateStr, String toDateStr, String valueThreshold) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ "," + source1 + ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ "," + source1 + ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        else{
             if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', " + source1 + ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', " + source1 + ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        return query;
    }

     
     public static String getDataByIntervalDatesForAllSource1(String functionName,
            String stringAttributes, String attributeTarget, String source2, String fromDateStr, String toDateStr, String valueThreshold) {
        String query = "";
        if (source2 != null && !source2.equals("")) {
            if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ ", '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',"+ source2+ ", '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        else{
             if(valueThreshold!=null && !valueThreshold.equals(""))
            { query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "', '" + fromDateStr + "', '" + toDateStr + "',"+ valueThreshold+");";
                
            }else{
            query =  "select * from " + functionName + "(ARRAY["
                + stringAttributes + "],'" + attributeTarget + "',  '" + fromDateStr + "', '" + toDateStr + "');";
            }
        }
        return query;
    }

}
