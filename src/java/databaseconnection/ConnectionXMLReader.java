/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package databaseconnection;

import categorization.CategorizationObject;
import categorization.Condition;
import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author aurea
 */
public class ConnectionXMLReader {

    //connection
    private String url = "";
    private String driver = "";
    private String user = "";
    private String password = "";

    //attribute
    private String attributeTableName = "";
    private String attributeIdName = "";
    private String attributeNameName = "";
    private String attributeCategoryName = "";

    //source1
    private String source1TableName = "";
    private String source1IdName = "";
    private String source1NameName = "";
    private String source1DescriptionName = "";
    private String source1CategoryName = "";

    //source2
    private String source2TableName = "";
    private String source2IdName = "";
    private String source2NameName = "";
    private String source2DescriptionName = "";

    //instancetable
    private String instanceTableName = "";
    private String instanceIdName = "";
    private String instanceSource1IdName = "";
    private String instanceSource2IdName = "";
    private String instanceTimeUTCName = "";
    private String instanceThresholdAttributeName = "";
    private ArrayList<String> listThresholdValues = new ArrayList<String>();
    private String rowUnit = "";

    //interface settings
    // private String timeRangesLabel = "";
    //private String timeRangesUnit = "";
    // private ArrayList<String> listTimeRangesOptions = new ArrayList<String>();
    private ArrayList<String> listTimeUnitOptions = new ArrayList<String>();
    private ArrayList<String> listAggregationFunctionOptions = new ArrayList<String>();

    //function names
    private String dataMaxFunctionTimeintervalThreshold = "";
    private String dataMinFunctionTimeintervalThreshold = "";
    private String dataAvgFunctionTimeintervalThreshold = "";
    private String dataStdFunctionTimeintervalThreshold = "";
    private String dataMedianFunctionTimeintervalThreshold = "";
    private String dataMaxFunctionTimeinterval = "";
    private String dataMinFunctionTimeinterval = "";
    private String dataAvgFunctionTimeinterval = "";
    private String dataStdFunctionTimeinterval = "";
    private String dataMedianFunctionTimeinterval = "";
    private String dataMaxFunctionTimeintervalThresholdForAllSource1 = "";
    private String dataMinFunctionTimeintervalThresholdForAllSource1 = "";
    private String dataAvgFunctionTimeintervalThresholdForAllSource1 = "";
    private String dataStdFunctionTimeintervalThresholdForAllSource1 = "";
    private String dataMedianFunctionTimeintervalThresholdForAllSource1 = "";
    private String dataMaxFunctionTimeintervalForAllSource1 = "";
    private String dataMinFunctionTimeintervalForAllSource1 = "";
    private String dataAvgFunctionTimeintervalForAllSource1 = "";
    private String dataStdFunctionTimeintervalForAllSource1 = "";
    private String dataMedianFunctionTimeintervalForAllSource1 = "";

    private String dataMaxminfunctionTimeintervalThreshold = "";
    private String dataMaxminfunctionTimeintervalThresholdForAllSource1 = "";
    private String dataMaxminfunctionTimeinterval = "";
    private String dataMaxminfunctionTimeintervalForAllSource1 = "";
    private String dataByTimeIntervalThreshold = "";
    private String dataByTimeIntervalThresholdForAllSource1 = "";
    private String dataByTimeInterval = "";
    private String dataByTimeIntervalForAllSource1 = "";

    //categorization
    private ArrayList<CategorizationObject> listCategorization = new ArrayList<CategorizationObject>();

    public String getUrl() {
        return url;
    }

    public String getDriver() {
        return driver;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public String getAttributeTableName() {
        return attributeTableName;
    }

    public String getAttributeIdName() {
        return attributeIdName;
    }

    public String getAttributeNameName() {
        return attributeNameName;
    }

    public String getAttributeCategoryName() {
        return attributeCategoryName;
    }

    public String getSource1TableName() {
        return source1TableName;
    }

    public String getSource1IdName() {
        return source1IdName;
    }

    public void setSource1IdName(String source1IdName) {
        this.source1IdName = source1IdName;
    }

    public String getSource1NameName() {
        return source1NameName;
    }

    public String getSource1DescriptionName() {
        return source1DescriptionName;
    }

    public void setSource1DescriptionName(String source1DescriptionName) {
        this.source1DescriptionName = source1DescriptionName;
    }
    
     public String getSource1CategoryName() {
        return source1CategoryName;
    }

    public void setSource1CategoryName(String source1CategoryName) {
        this.source1CategoryName = source1CategoryName;
    }

    public String getSource2TableName() {
        return source2TableName;
    }

    public String getSource2IdName() {
        return source2IdName;
    }

    public String getSource2NameName() {
        return source2NameName;
    }

    public String getSource2DescriptionName() {
        return source2DescriptionName;
    }

    public String getInstanceTableName() {
        return instanceTableName;
    }

    public String getInstanceIdName() {
        return instanceIdName;
    }

    public String getInstanceSource1IdName() {
        return instanceSource1IdName;
    }

    public String getInstanceSource2IdName() {
        return instanceSource2IdName;
    }

    public String getInstanceTimeUTCName() {
        return instanceTimeUTCName;
    }

    public String getInstanceThresholdAttributeName() {
        return instanceThresholdAttributeName;
    }

    public ArrayList<String> getListThresholdValues() {
        return listThresholdValues;
    }

    /*  public String getTimeRangesLabel() {
        return timeRangesLabel;
    }

    public ArrayList<String> getListTimeRangesOptions() {
        return listTimeRangesOptions;
    }*/
    public ArrayList<String> getListTimeUnitOptions() {
        return listTimeUnitOptions;
    }

    public ArrayList<String> getListAggregationFunctionOptions() {
        return listAggregationFunctionOptions;
    }

    /* public String getTimeRangesUnit() {
        return timeRangesUnit;
    }*/
    public String getDataMaxFunctionTimeintervalThreshold() {
        return dataMaxFunctionTimeintervalThreshold;
    }

    public String getDataMinFunctionTimeintervalThreshold() {
        return dataMinFunctionTimeintervalThreshold;
    }

    public String getDataAvgFunctionTimeintervalThreshold() {
        return dataAvgFunctionTimeintervalThreshold;
    }

    public String getDataStdFunctionTimeintervalThreshold() {
        return dataStdFunctionTimeintervalThreshold;
    }

    public String getDataMedianFunctionTimeintervalThreshold() {
        return dataMedianFunctionTimeintervalThreshold;
    }

    public String getDataMedianFunctionTimeinterval() {
        return dataMedianFunctionTimeinterval;
    }

    public String getDataMedianFunctionTimeintervalThresholdForAllSource1() {
        return dataMedianFunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataMedianFunctionTimeintervalForAllSource1() {
        return dataMedianFunctionTimeintervalForAllSource1;
    }

    public String getDataMaxFunctionTimeinterval() {
        return dataMaxFunctionTimeinterval;
    }

    public String getDataMinFunctionTimeinterval() {
        return dataMinFunctionTimeinterval;
    }

    public String getDataAvgFunctionTimeinterval() {
        return dataAvgFunctionTimeinterval;
    }

    public String getDataStdFunctionTimeinterval() {
        return dataStdFunctionTimeinterval;
    }

    public String getDataMaxFunctionTimeintervalThresholdForAllSource1() {
        return dataMaxFunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataMinFunctionTimeintervalThresholdForAllSource1() {
        return dataMinFunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataAvgFunctionTimeintervalThresholdForAllSource1() {
        return dataAvgFunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataStdFunctionTimeintervalThresholdForAllSource1() {
        return dataStdFunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataMaxFunctionTimeintervalForAllSource1() {
        return dataMaxFunctionTimeintervalForAllSource1;
    }

    public String getDataMinFunctionTimeintervalForAllSource1() {
        return dataMinFunctionTimeintervalForAllSource1;
    }

    public String getDataAvgFunctionTimeintervalForAllSource1() {
        return dataAvgFunctionTimeintervalForAllSource1;
    }

    public String getDataStdFunctionTimeintervalForAllSource1() {
        return dataStdFunctionTimeintervalForAllSource1;
    }

    public String getRowUnit() {
        return rowUnit;
    }

    public void setRowUnit(String rowUnit) {
        this.rowUnit = rowUnit;
    }

    /*public String getTimeRangesUnit() {
        return timeRangesUnit;
    }

    public void setTimeRangesUnit(String timeRangesUnit) {
        this.timeRangesUnit = timeRangesUnit;
    }*/
    public ArrayList<CategorizationObject> getListCategorization() {
        return listCategorization;
    }

    public void setListCategorization(ArrayList<CategorizationObject> listCategorization) {
        this.listCategorization = listCategorization;
    }

    public String getDataMaxminfunctionTimeintervalThreshold() {
        return dataMaxminfunctionTimeintervalThreshold;
    }

    public void setDataMaxminfunctionTimeintervalThreshold(String dataMaxminfunctionTimeintervalThreshold) {
        this.dataMaxminfunctionTimeintervalThreshold = dataMaxminfunctionTimeintervalThreshold;
    }

    public String getDataMaxminfunctionTimeintervalThresholdForAllSource1() {
        return dataMaxminfunctionTimeintervalThresholdForAllSource1;
    }

    public void setDataMaxminfunctionTimeintervalThresholdForAllSource1(String dataMaxminfunctionTimeintervalThresholdForAllSource1) {
        this.dataMaxminfunctionTimeintervalThresholdForAllSource1 = dataMaxminfunctionTimeintervalThresholdForAllSource1;
    }

    public String getDataMaxminfunctionTimeinterval() {
        return dataMaxminfunctionTimeinterval;
    }

    public void setDataMaxminfunctionTimeinterval(String dataMaxminfunctionTimeinterval) {
        this.dataMaxminfunctionTimeinterval = dataMaxminfunctionTimeinterval;
    }

    public String getDataMaxminfunctionTimeintervalForAllSource1() {
        return dataMaxminfunctionTimeintervalForAllSource1;
    }

    public void setDataMaxminfunctionTimeintervalForAllSource1(String dataMaxminfunctionTimeintervalForAllSource1) {
        this.dataMaxminfunctionTimeintervalForAllSource1 = dataMaxminfunctionTimeintervalForAllSource1;
    }

    public String getDataByTimeIntervalThreshold() {
        return dataByTimeIntervalThreshold;
    }

    public void setDataByTimeIntervalThreshold(String dataByTimeIntervalThreshold) {
        this.dataByTimeIntervalThreshold = dataByTimeIntervalThreshold;
    }

    public String getDataByTimeIntervalThresholdForAllSource1() {
        return dataByTimeIntervalThresholdForAllSource1;
    }

    public void setDataByTimeIntervalThresholdForAllSource1(String dataByTimeIntervalThresholdForAllSource1) {
        this.dataByTimeIntervalThresholdForAllSource1 = dataByTimeIntervalThresholdForAllSource1;
    }

    public String getDataByTimeInterval() {
        return dataByTimeInterval;
    }

    public void setDataByTimeInterval(String dataByTimeInterval) {
        this.dataByTimeInterval = dataByTimeInterval;
    }

    public String getDataByTimeIntervalForAllSource1() {
        return dataByTimeIntervalForAllSource1;
    }

    public void setDataByTimeIntervalForAllSource1(String dataByTimeIntervalForAllSource1) {
        this.dataByTimeIntervalForAllSource1 = dataByTimeIntervalForAllSource1;
    }

    public void loadConnectionXml(String nameXMLFile) {
        try {

            File cXmlFile = new File(nameXMLFile);
            //System.out.println("Exists? " + cXmlFile.exists());
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(cXmlFile);

            doc.getDocumentElement().normalize();

            //connection
            NodeList connectionTagList = doc.getElementsByTagName("connection");
            Node connectionTagNode = connectionTagList.item(0);
            if (connectionTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) connectionTagNode;
                driver = eElement.getElementsByTagName("driver").item(0).getTextContent();
                String prefix = eElement.getElementsByTagName("prefix").item(0).getTextContent();
                String ipserver = eElement.getElementsByTagName("ipserver").item(0).getTextContent();
                String port = eElement.getElementsByTagName("port").item(0).getTextContent();
                String database = eElement.getElementsByTagName("database").item(0).getTextContent();
                url = prefix + ipserver + ":" + port + "/" + database;
                user = eElement.getElementsByTagName("user").item(0).getTextContent();
                password = eElement.getElementsByTagName("password").item(0).getTextContent();
            }

            //attributeTable
            NodeList attributeTableTagList = doc.getElementsByTagName("attributetable");
            Node atributeTableNode = attributeTableTagList.item(0);
            if (atributeTableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) atributeTableNode;
                attributeTableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                attributeIdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                attributeNameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                attributeCategoryName = eElement.getElementsByTagName("category").item(0).getTextContent();
            }

            //source1table
            NodeList source1TableTagList = doc.getElementsByTagName("source1table");
            Node source1TableNode = source1TableTagList.item(0);
            if (source1TableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) source1TableNode;
                source1TableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                source1IdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                source1NameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                source1DescriptionName = eElement.getElementsByTagName("description").item(0).getTextContent();
                source1CategoryName = eElement.getElementsByTagName("category").item(0).getTextContent();
            }

            //source2table
            NodeList source2TableTagList = doc.getElementsByTagName("source2table");
            Node source2TableNode = source2TableTagList.item(0);
            if (source2TableNode != null) {

                if (source2TableNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) source2TableNode;
                    source2TableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                    source2IdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                    source2NameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                    source2DescriptionName = eElement.getElementsByTagName("description").item(0).getTextContent();
                }
            } else {

            }

            //instancetable
            NodeList instanceTableTagList = doc.getElementsByTagName("instancetable");
            Node instanceTableNode = instanceTableTagList.item(0);
            //System.out.println("\nCurrent Element :" + instanceTableNode.getNodeName());
            if (instanceTableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) instanceTableNode;
                instanceTableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                instanceIdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                instanceSource1IdName = eElement.getElementsByTagName("source1_id").item(0).getTextContent();
                instanceSource2IdName = eElement.getElementsByTagName("source2_id").item(0).getTextContent();
                instanceTimeUTCName = eElement.getElementsByTagName("time_utc").item(0).getTextContent();
                instanceThresholdAttributeName = eElement.getElementsByTagName("threshold_attribute").item(0).getTextContent();

                NodeList instanceThresholdAttributeTagList = doc.getElementsByTagName("threshold_attribute_options");
                for (int temp = 0; temp < instanceThresholdAttributeTagList.getLength(); temp++) {
                    Node thresholdValueNode = instanceThresholdAttributeTagList.item(temp);
                    if (thresholdValueNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) thresholdValueNode;
                        listThresholdValues.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }
            }

            //interface settings
            //instancetable
            NodeList timeRangesTagList = doc.getElementsByTagName("time_ranges");
            Node timeRangesTagNode = timeRangesTagList.item(0);
            //System.out.println("\nCurrent Element :" + timeRangesTagNode.getNodeName());
            if (timeRangesTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) timeRangesTagNode;
                rowUnit = eElement.getElementsByTagName("row_unit").item(0).getTextContent();
                //timeRangesLabel = eElement.getElementsByTagName("label").item(0).getTextContent();
                //timeRangesUnit = eElement.getElementsByTagName("time_ranges_unit").item(0).getTextContent();

                /* NodeList timeRangesOptionsTagList = doc.getElementsByTagName("time_ranges_options");
                for (int temp = 0; temp < timeRangesOptionsTagList.getLength(); temp++) {
                    Node timeRangesOptionNode = timeRangesOptionsTagList.item(temp);
                    if (timeRangesOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) timeRangesOptionNode;
                        listTimeRangesOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }*/
                NodeList timeUnitOptionsTagList = doc.getElementsByTagName("time_unit_options");
                for (int temp = 0; temp < timeUnitOptionsTagList.getLength(); temp++) {
                    Node timeUnitOptionNode = timeUnitOptionsTagList.item(temp);
                    if (timeUnitOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) timeUnitOptionNode;
                        listTimeUnitOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }

                NodeList aggregationFunctionOptionsTagList = doc.getElementsByTagName("aggregation_function_options");
                for (int temp = 0; temp < aggregationFunctionOptionsTagList.getLength(); temp++) {
                    Node aggregationFunctionOptionNode = aggregationFunctionOptionsTagList.item(temp);
                    if (aggregationFunctionOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) aggregationFunctionOptionNode;
                        listAggregationFunctionOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }
            }

            //function names
            NodeList functionNamesTagList = doc.getElementsByTagName("functions_postgresql");
            Node functionNamesTagNode = functionNamesTagList.item(0);

            if (functionNamesTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) functionNamesTagNode;
                dataMaxFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_maxfunction_timeinterval_threshold").item(0).getTextContent();
                dataMinFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_minfunction_timeinterval_threshold").item(0).getTextContent();
                dataAvgFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_avgfunction_timeinterval_threshold").item(0).getTextContent();
                dataStdFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold").item(0).getTextContent();
                dataMedianFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_medianfunction_timeinterval_threshold").item(0).getTextContent();

                dataMaxFunctionTimeinterval = eElement.getElementsByTagName("data_maxfunction_timeinterval").item(0).getTextContent();
                dataMinFunctionTimeinterval = eElement.getElementsByTagName("data_minfunction_timeinterval").item(0).getTextContent();
                dataAvgFunctionTimeinterval = eElement.getElementsByTagName("data_avgfunction_timeinterval").item(0).getTextContent();
                dataStdFunctionTimeinterval = eElement.getElementsByTagName("data_stdfunction_timeinterval").item(0).getTextContent();
                dataMedianFunctionTimeinterval = eElement.getElementsByTagName("data_medianfunction_timeinterval").item(0).getTextContent();

                dataMaxFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_maxfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMinFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_minfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataAvgFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_avgfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataStdFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMedianFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();

                dataMaxFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_maxfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataMinFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_minfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataAvgFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_avgfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataStdFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataMedianFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_forallsource1").item(0).getTextContent();

                dataMaxminfunctionTimeintervalThreshold = eElement.getElementsByTagName("data_maxminfunction_timeinterval_threshold").item(0).getTextContent();
                dataMaxminfunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_maxminfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMaxminfunctionTimeinterval = eElement.getElementsByTagName("data_maxminfunction_timeinterval").item(0).getTextContent();
                dataMaxminfunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_maxminfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataByTimeIntervalThreshold = eElement.getElementsByTagName("data_by_timeinterval_threshold").item(0).getTextContent();
                dataByTimeIntervalThresholdForAllSource1 = eElement.getElementsByTagName("data_by_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataByTimeInterval = eElement.getElementsByTagName("data_by_timeinterval").item(0).getTextContent();
                dataByTimeIntervalForAllSource1 = eElement.getElementsByTagName("data_by_timeinterval_forallsource1").item(0).getTextContent();

            }

            //categorizations
            NodeList categorizationTagList = doc.getElementsByTagName("categorization");
            for (int temp = 0; temp < categorizationTagList.getLength(); temp++) {
                Node categorizationNode = categorizationTagList.item(temp);
                if (categorizationNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element valueElement = (Element) categorizationNode;
                    String name = valueElement.getElementsByTagName("name_categorization").item(0).getTextContent();
                    String description = valueElement.getElementsByTagName("description").item(0).getTextContent();

                    String numberConditions = valueElement.getElementsByTagName("number_conditions").item(0).getTextContent();
                    String numberClasses = valueElement.getElementsByTagName("number_classes").item(0).getTextContent();
                    ArrayList<Condition> listConditions = new ArrayList<Condition>();
                    NodeList conditionTagList = valueElement.getElementsByTagName("condition");
                    for (int temp2 = 0; temp2 < conditionTagList.getLength(); temp2++) {
                        Node conditionNode = conditionTagList.item(temp2);
                        if (conditionNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element conditionElement = (Element) conditionNode;
                            String symbol1 = conditionElement.getElementsByTagName("symbol1").item(0).getTextContent();
                            String value1 = conditionElement.getElementsByTagName("value1").item(0).getTextContent();
                            String symbol2 = conditionElement.getElementsByTagName("symbol2").item(0).getTextContent();
                            String value2 = conditionElement.getElementsByTagName("value2").item(0).getTextContent();
                            String classValue = conditionElement.getElementsByTagName("class_value").item(0).getTextContent();
                            listConditions.add(new Condition(symbol1, value1, symbol2, value2, classValue));

                        }
                    }
                    listCategorization.add(new CategorizationObject(name, description, numberConditions, numberClasses, listConditions));

                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    
    
    public void loadConnectionXml(InputStream inputStream) {
        try {

             DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(inputStream);

            doc.getDocumentElement().normalize();

            //connection
            NodeList connectionTagList = doc.getElementsByTagName("connection");
            Node connectionTagNode = connectionTagList.item(0);
            if (connectionTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) connectionTagNode;
                driver = eElement.getElementsByTagName("driver").item(0).getTextContent();
                String prefix = eElement.getElementsByTagName("prefix").item(0).getTextContent();
                String ipserver = eElement.getElementsByTagName("ipserver").item(0).getTextContent();
                String port = eElement.getElementsByTagName("port").item(0).getTextContent();
                String database = eElement.getElementsByTagName("database").item(0).getTextContent();
                url = prefix + ipserver + ":" + port + "/" + database;
                user = eElement.getElementsByTagName("user").item(0).getTextContent();
                password = eElement.getElementsByTagName("password").item(0).getTextContent();
            }

            //attributeTable
            NodeList attributeTableTagList = doc.getElementsByTagName("attributetable");
            Node atributeTableNode = attributeTableTagList.item(0);
            if (atributeTableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) atributeTableNode;
                attributeTableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                attributeIdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                attributeNameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                attributeCategoryName = eElement.getElementsByTagName("category").item(0).getTextContent();
            }

            //source1table
            NodeList source1TableTagList = doc.getElementsByTagName("source1table");
            Node source1TableNode = source1TableTagList.item(0);
            if (source1TableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) source1TableNode;
                source1TableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                source1IdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                source1NameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                source1DescriptionName = eElement.getElementsByTagName("description").item(0).getTextContent();
                source1CategoryName = eElement.getElementsByTagName("category").item(0).getTextContent();
            }

            //source2table
            NodeList source2TableTagList = doc.getElementsByTagName("source2table");
            Node source2TableNode = source2TableTagList.item(0);
            if (source2TableNode != null) {

                if (source2TableNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) source2TableNode;
                    source2TableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                    source2IdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                    source2NameName = eElement.getElementsByTagName("name").item(0).getTextContent();
                    source2DescriptionName = eElement.getElementsByTagName("description").item(0).getTextContent();
                }
            } else {

            }

            //instancetable
            NodeList instanceTableTagList = doc.getElementsByTagName("instancetable");
            Node instanceTableNode = instanceTableTagList.item(0);
            //System.out.println("\nCurrent Element :" + instanceTableNode.getNodeName());
            if (instanceTableNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) instanceTableNode;
                instanceTableName = eElement.getElementsByTagName("tablename").item(0).getTextContent();
                instanceIdName = eElement.getElementsByTagName("id").item(0).getTextContent();
                instanceSource1IdName = eElement.getElementsByTagName("source1_id").item(0).getTextContent();
                instanceSource2IdName = eElement.getElementsByTagName("source2_id").item(0).getTextContent();
                instanceTimeUTCName = eElement.getElementsByTagName("time_utc").item(0).getTextContent();
                instanceThresholdAttributeName = eElement.getElementsByTagName("threshold_attribute").item(0).getTextContent();

                NodeList instanceThresholdAttributeTagList = doc.getElementsByTagName("threshold_attribute_options");
                for (int temp = 0; temp < instanceThresholdAttributeTagList.getLength(); temp++) {
                    Node thresholdValueNode = instanceThresholdAttributeTagList.item(temp);
                    if (thresholdValueNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) thresholdValueNode;
                        listThresholdValues.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }
            }

            //interface settings
            //instancetable
            NodeList timeRangesTagList = doc.getElementsByTagName("time_ranges");
            Node timeRangesTagNode = timeRangesTagList.item(0);
            //System.out.println("\nCurrent Element :" + timeRangesTagNode.getNodeName());
            if (timeRangesTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) timeRangesTagNode;
                rowUnit = eElement.getElementsByTagName("row_unit").item(0).getTextContent();
                //timeRangesLabel = eElement.getElementsByTagName("label").item(0).getTextContent();
                //timeRangesUnit = eElement.getElementsByTagName("time_ranges_unit").item(0).getTextContent();

                /* NodeList timeRangesOptionsTagList = doc.getElementsByTagName("time_ranges_options");
                for (int temp = 0; temp < timeRangesOptionsTagList.getLength(); temp++) {
                    Node timeRangesOptionNode = timeRangesOptionsTagList.item(temp);
                    if (timeRangesOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) timeRangesOptionNode;
                        listTimeRangesOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }*/
                NodeList timeUnitOptionsTagList = doc.getElementsByTagName("time_unit_options");
                for (int temp = 0; temp < timeUnitOptionsTagList.getLength(); temp++) {
                    Node timeUnitOptionNode = timeUnitOptionsTagList.item(temp);
                    if (timeUnitOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) timeUnitOptionNode;
                        listTimeUnitOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }

                NodeList aggregationFunctionOptionsTagList = doc.getElementsByTagName("aggregation_function_options");
                for (int temp = 0; temp < aggregationFunctionOptionsTagList.getLength(); temp++) {
                    Node aggregationFunctionOptionNode = aggregationFunctionOptionsTagList.item(temp);
                    if (aggregationFunctionOptionNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element valueElement = (Element) aggregationFunctionOptionNode;
                        listAggregationFunctionOptions.add(valueElement.getElementsByTagName("value").item(0).getTextContent());
                    }
                }
            }

            //function names
            NodeList functionNamesTagList = doc.getElementsByTagName("functions_postgresql");
            Node functionNamesTagNode = functionNamesTagList.item(0);

            if (functionNamesTagNode.getNodeType() == Node.ELEMENT_NODE) {
                Element eElement = (Element) functionNamesTagNode;
                dataMaxFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_maxfunction_timeinterval_threshold").item(0).getTextContent();
                dataMinFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_minfunction_timeinterval_threshold").item(0).getTextContent();
                dataAvgFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_avgfunction_timeinterval_threshold").item(0).getTextContent();
                dataStdFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold").item(0).getTextContent();
                dataMedianFunctionTimeintervalThreshold = eElement.getElementsByTagName("data_medianfunction_timeinterval_threshold").item(0).getTextContent();

                dataMaxFunctionTimeinterval = eElement.getElementsByTagName("data_maxfunction_timeinterval").item(0).getTextContent();
                dataMinFunctionTimeinterval = eElement.getElementsByTagName("data_minfunction_timeinterval").item(0).getTextContent();
                dataAvgFunctionTimeinterval = eElement.getElementsByTagName("data_avgfunction_timeinterval").item(0).getTextContent();
                dataStdFunctionTimeinterval = eElement.getElementsByTagName("data_stdfunction_timeinterval").item(0).getTextContent();
                dataMedianFunctionTimeinterval = eElement.getElementsByTagName("data_medianfunction_timeinterval").item(0).getTextContent();

                dataMaxFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_maxfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMinFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_minfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataAvgFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_avgfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataStdFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMedianFunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();

                dataMaxFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_maxfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataMinFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_minfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataAvgFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_avgfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataStdFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataMedianFunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_stdfunction_timeinterval_forallsource1").item(0).getTextContent();

                dataMaxminfunctionTimeintervalThreshold = eElement.getElementsByTagName("data_maxminfunction_timeinterval_threshold").item(0).getTextContent();
                dataMaxminfunctionTimeintervalThresholdForAllSource1 = eElement.getElementsByTagName("data_maxminfunction_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataMaxminfunctionTimeinterval = eElement.getElementsByTagName("data_maxminfunction_timeinterval").item(0).getTextContent();
                dataMaxminfunctionTimeintervalForAllSource1 = eElement.getElementsByTagName("data_maxminfunction_timeinterval_forallsource1").item(0).getTextContent();
                dataByTimeIntervalThreshold = eElement.getElementsByTagName("data_by_timeinterval_threshold").item(0).getTextContent();
                dataByTimeIntervalThresholdForAllSource1 = eElement.getElementsByTagName("data_by_timeinterval_threshold_forallsource1").item(0).getTextContent();
                dataByTimeInterval = eElement.getElementsByTagName("data_by_timeinterval").item(0).getTextContent();
                dataByTimeIntervalForAllSource1 = eElement.getElementsByTagName("data_by_timeinterval_forallsource1").item(0).getTextContent();

            }

            //categorizations
            NodeList categorizationTagList = doc.getElementsByTagName("categorization");
            for (int temp = 0; temp < categorizationTagList.getLength(); temp++) {
                Node categorizationNode = categorizationTagList.item(temp);
                if (categorizationNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element valueElement = (Element) categorizationNode;
                    String name = valueElement.getElementsByTagName("name_categorization").item(0).getTextContent();
                    String description = valueElement.getElementsByTagName("description").item(0).getTextContent();

                    String numberConditions = valueElement.getElementsByTagName("number_conditions").item(0).getTextContent();
                    String numberClasses = valueElement.getElementsByTagName("number_classes").item(0).getTextContent();
                    ArrayList<Condition> listConditions = new ArrayList<Condition>();
                    NodeList conditionTagList = valueElement.getElementsByTagName("condition");
                    for (int temp2 = 0; temp2 < conditionTagList.getLength(); temp2++) {
                        Node conditionNode = conditionTagList.item(temp2);
                        if (conditionNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element conditionElement = (Element) conditionNode;
                            String symbol1 = conditionElement.getElementsByTagName("symbol1").item(0).getTextContent();
                            String value1 = conditionElement.getElementsByTagName("value1").item(0).getTextContent();
                            String symbol2 = conditionElement.getElementsByTagName("symbol2").item(0).getTextContent();
                            String value2 = conditionElement.getElementsByTagName("value2").item(0).getTextContent();
                            String classValue = conditionElement.getElementsByTagName("class_value").item(0).getTextContent();
                            listConditions.add(new Condition(symbol1, value1, symbol2, value2, classValue));

                        }
                    }
                    listCategorization.add(new CategorizationObject(name, description, numberConditions, numberClasses, listConditions));

                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void main(String argv[]) {
        String nameXMLFile = "./web/xmlConnections/ScintillationConnectionXML.xml";
        ConnectionXMLReader connectionXMLReader = new ConnectionXMLReader();
        connectionXMLReader.loadConnectionXml(nameXMLFile);

    }

}
