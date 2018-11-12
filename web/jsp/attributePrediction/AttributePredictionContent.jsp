<%-- 
    Document   : AttributePredictionContent
    Created on : Apr 5, 2016, 4:26:23 PM
    Author     : aurea
--%>






<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="weka.classifiers.functions.Logistic"%>
<%@page import="weka.classifiers.functions.SMOreg"%>
<%@page import="weka.classifiers.functions.GaussianProcesses"%>
<%@page import="weka.classifiers.functions.IsotonicRegression"%>
<%@page import="weka.classifiers.trees.REPTree"%>
<%@page import="utils.Operations"%>
<%@page import="utils.Util"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="weka.classifiers.functions.LinearRegression"%>
<%@page import="weka.core.Instance"%>
<%@page import="weka.core.Instances"%>
<%@page import="weka.core.Attribute"%>
<%@page import="weka.core.FastVector"%>
<%@page import="classification.LinearRegressionRegression"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="dataMaker.Matrix"%>
<%@page import="java.awt.Color"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervals = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");

    String valueType = (String) session.getAttribute("aggregationFunction");
    if (listTimeIntervals != null) {
        ConnectionXMLReader connectionXMLReader = (ConnectionXMLReader) session.getAttribute("connectionXMLReader");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");
        int predictedAttributeId = Integer.valueOf(request.getParameter("predictedAttributeId"));
        String techniquePrediction = request.getParameter("techniquePrediction");
        TimeInterval timeInterval = listTimeIntervals.get(predictedAttributeId);

        String aggregationFunction = (String) session.getAttribute("aggregationFunction");
        String nameAttribute = "'" + timeInterval.getNameAttribute() + "'";

        String user = (String) session.getAttribute("user");
        String driver = (String) session.getAttribute("driver");
        String username = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String url = (String) session.getAttribute("url");
        String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
        String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
        String valueThreshold = (String) session.getAttribute("valueThreshold");

        long secValueUnitTimeInterval = 0;
        if (unitTimeInterval.equals("year")) {
            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 365;
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(365, TimeUnit.DAYS));
        } else if (unitTimeInterval.equals("month")) {
            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 30;
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(30, TimeUnit.DAYS));
        } else if (unitTimeInterval.equals("day")) {
            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24;
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.DAYS));
        } else if (unitTimeInterval.equals("hour")) {
            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60;
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.HOURS));
        } else if (unitTimeInterval.equals("minute")) {
            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60;
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.MINUTES));
        }

        ArrayList<String> listLabelsRow = (ArrayList<String>) timeInterval.getListLabelsY().clone();
        ArrayList<String> listLabelsCol = (ArrayList<String>) timeInterval.getListLabelsX().clone();

        String predictedLabelRow = Util.getPredictedLabelRow(listLabelsRow.get(listLabelsRow.size() - 1), connectionXMLReader.getRowUnit());
        listLabelsRow.add(predictedLabelRow);

        String predictedEndDate = Util.getPredictedEndDate(timeInterval.getEndDate(), connectionXMLReader.getRowUnit());

        String query = "";

        String idSource1 = "";
        if (timeInterval.getValueSource() != null && !timeInterval.getValueSource().equals("")) {
            //getting id of source 1
            idSource1 = timeInterval.getIdSource();

        }

        String idSource2 = null;

        if (timeInterval.getIdSource2() != null && !timeInterval.getIdSource2().equals("")) {
            //getting id of source 2

            idSource2 = timeInterval.getIdSource2();
        }

        if (connectionXMLReader.getInstanceThresholdAttributeName() != null && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {
            // System.out.println("there is threshold");

            if (aggregationFunction.equals("max")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMaxFunctionTimeintervalThreshold(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("avg")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataAvgFunctionTimeintervalThreshold(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("min")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("std")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("median")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMedianFunctionTimeintervalThreshold(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval, valueThreshold);
            }

        } else {
            //System.out.println("there is no threshold");
            if (aggregationFunction.equals("max")) {

                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMaxFunctionTimeinterval(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("avg")) {
                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataAvgFunctionTimeinterval(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("min")) {
                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMinFunctionTimeinterval(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("std")) {
                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataStdFunctionTimeinterval(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("median")) {
                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMedianFunctionTimeinterval(),
                        nameAttribute, idSource2, idSource1, timeInterval.getInitDate(), predictedEndDate, secValueUnitTimeInterval);
            }
        }

        // query = "select * from get" + aggregationFunction + "bytimeintervalandelevation(ARRAY[" + nameAttribute + "]," + source2 + "," + source1 + ", '" + timeInterval.getInitDate() + "', '"
        //   + dateformatPredictedDay + "',"  + secValueUnitTimeInterval + ", " + valueThreshold + ");";
        System.out.println(query);
        TimeInterval inclPredictedDayTimeInterval = new TimeInterval(new Matrix(listLabelsRow.size(),
                listLabelsCol.size()), timeInterval.getInitDate(), predictedEndDate, timeInterval.getInitHour(),
                timeInterval.getEndHour(), timeInterval.getNameAttribute(), timeInterval.getCluster(), listLabelsCol, listLabelsRow,
                timeInterval.getNameSource(),
                timeInterval.getValueSource(), timeInterval.getIdSource(), timeInterval.getNameSource2(), timeInterval.getIdSource2(), timeInterval.getCategorySource(), -1);
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultCategorySet = null;
        Class.forName(driver).newInstance();
        connection = DriverManager.getConnection(url, username, password);
        preparedStatement = connection.prepareStatement(query);
        resultCategorySet = preparedStatement.executeQuery();
        while (resultCategorySet.next()) {
            try {
                String timeInstance = resultCategorySet.getString(connectionXMLReader.getInstanceTimeUTCName());

                Integer positionY = Util.getRowLabelIndex(listLabelsRow, timeInstance, connectionXMLReader.getRowUnit());
                Integer positionX = Util.getColumnLabelIndex(listLabelsCol, timeInstance, unitTimeInterval, connectionXMLReader.getRowUnit());
                String round = resultCategorySet.getString("round");
                String[] values = round.replace("{", "").replace("}", "").split(",");
                Double value = Double.valueOf(values[0]);
                inclPredictedDayTimeInterval.getMatrix().setValue(positionY, positionX, value);
            } catch (Exception e) {

            }
        }
        resultCategorySet.close();
        preparedStatement.close();
        connection.close();

        ArrayList<Object> listModels = new ArrayList<Object>();

// file to pass to Weka
        FastVector fvWekaAttributes = new FastVector(3);
        Attribute wekaAttributeX = new Attribute("x");
        fvWekaAttributes.addElement(wekaAttributeX);
        Attribute wekaAttributeY = new Attribute("y");
        fvWekaAttributes.addElement(wekaAttributeY);

        // Declare the class attribute along with its values
        FastVector fvClassVal = new FastVector(256);

        // Create instances set
        Instances dataInstances = null;

        for (int j = -1; j <= 255; j++) {
            fvClassVal.addElement(String.valueOf(j));
        }
        Attribute ClassAttribute = null;

        ClassAttribute = new Attribute("theClass");
        //Clasifier-        ClassAttribute = new Attribute("theClass", fvClassVal);

        fvWekaAttributes.addElement(ClassAttribute);

        Matrix inclPredictedDayMatrix = inclPredictedDayTimeInterval.getProcessedMatrix();
        //int[] initPositions = inclPredictedDayMatrix.getInterpolatedInitialPositions();

        int endPosition = inclPredictedDayMatrix.getCols() - 1;
        while (inclPredictedDayMatrix.getValue(0, endPosition) == -1 && endPosition >= 0) {
            endPosition--;
        }
        //int numberExistingCols = endPosition - initPositions[0] + 1;

        for (int i = 0; i < inclPredictedDayMatrix.getCols(); i++) {// numberExistingCols; i++) {
            dataInstances = new Instances("Rel", fvWekaAttributes, inclPredictedDayMatrix.getRows() - 1);
            for (int j = 0; j < inclPredictedDayMatrix.getRows() - 1; j++) {

                // Create the instance
                int currentCol = i;//initPositions[j] + i;

                if (currentCol >= 0 && currentCol < inclPredictedDayMatrix.getCols()) {
                    double value = inclPredictedDayMatrix.getValue(j, currentCol);
                    Instance iExample = new Instance(3);
                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(0), j);
                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(1), i);

                    int intvalue = (int) value;
                    if (intvalue < -1) {
                        intvalue = -1;
                    }

                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(2), intvalue);

                    //Classifier--   iExample.setValue((Attribute) fvWekaAttributes.elementAt(2), String.valueOf(intvalue));
                    // add the instance
                    dataInstances.add(iExample);
                }

            }
            dataInstances.setClassIndex(2);
            if (techniquePrediction.equals("linearRegression")) {
                LinearRegression linearmodel = new LinearRegression();
                linearmodel.buildClassifier(dataInstances);
                listModels.add(linearmodel);
            } else {
                if (techniquePrediction.equals("isotonicRegression")) {
                    IsotonicRegression isomodel = new IsotonicRegression();
                    isomodel.buildClassifier(dataInstances);
                    listModels.add(isomodel);
                } else {
                    if (techniquePrediction.equals("gaussianProcesses")) {
                        GaussianProcesses gaumodel = new GaussianProcesses();
                        gaumodel.buildClassifier(dataInstances);
                        listModels.add(gaumodel);
                    }
                }
            }

        }
%>
<br>
<table style="width:760px; text-align: center; margin:0 auto; margin:auto; border-color: black; " border="1"  >

    <tr>
        <%            int indexColorBackground = timeInterval.getIndexColorCluster();
            Color colorBackground = colorScaleBackground[indexColorBackground];
            String fontColor = utils.Util.getColorByLuminance(colorBackground);

        %>


        <td style="width: 500px;height: 500px; text-align: center; ">
               <table style="text-align: center; margin:0 auto; margin:auto;background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen()
                   );%>,<%out.print(colorBackground.getBlue());%>);">

                <tr style="">

                    <th  style="font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;" colspan="2" >#<%out.print((timeInterval.getCluster()) + " - " + timeInterval.getNameAttribute());%>

                    </th>
                </tr>

                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:11px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" ><%out.print(timeInterval.getNameSource() + " " + timeInterval.getValueSource());%></td>
                </tr>
                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:9px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" ><%out.print(timeInterval.getInitDate() + " - " + timeInterval.getEndDate());%></td>
                </tr>
                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:9px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" ><%out.print(timeInterval.getInitHour() + ":00 - " + timeInterval.getEndHour() + ":00");%></td>
                </tr>
                <tr>

                        <td style="width: 760px; background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen()
                            );%>,<%out.print(colorBackground.getBlue());%>);" >
                        <table style='width: 760px; height:650px; border-style:solid;' >
                            <%

                                double sizeCellWidth = (400) / inclPredictedDayMatrix.getCols();
                                double sizeCellHeight = sizeCellWidth;//(650) / (inclPredictedDayMatrix.getRows() - 1);
                                for (int mRow = 0; mRow < inclPredictedDayMatrix.getRows() - 1; mRow++) {%>
                            <tr>     
                                <td style="color:<%out.print(fontColor);%>;font-size:12px; width: 90px"><b><%out.print(listLabelsRow.get(mRow));%></b></td>
                                        <%for (int mCol = 0; mCol < inclPredictedDayMatrix.getCols(); mCol++) {
                                                int positionColorCell = (int) inclPredictedDayMatrix.getValue(mRow, mCol);
                                                boolean interpolatedFlag = (boolean) inclPredictedDayMatrix.getFlag(mRow, mCol);
                                                double originalValue = Double.NaN;
                                                if (inclPredictedDayMatrix.getOriginalValue(mRow, mCol) != Double.NEGATIVE_INFINITY) {
                                                    originalValue = inclPredictedDayMatrix.getOriginalValue(mRow, mCol);
                                                }
                                                Color colorCell = null;
                                                if (positionColorCell >= 0) {
                                                    colorCell = colorScaleCell[255 - positionColorCell];
                                                } else {
                                                    colorCell = Color.gray;
                                                }

                                                int red = colorCell.getRed();
                                                int green = colorCell.getGreen();
                                                int blue = colorCell.getBlue();
                                        %>
                                <td title="<%out.print(listLabelsRow.get(mRow) + "\n" + listLabelsCol.get(mCol) + " \n" + valueType + " value: " + originalValue);%>" 
                                    style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                    color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);  
                                    <%if (interpolatedFlag == true) {
                                    %>
                                    border: 1px solid red;
                                    <%}%>"
                                    width="<%out.print(sizeCellWidth);%>px" height="<%out.print(sizeCellHeight);%>px">

                                </td>
                                <% }%>
                            </tr>
                            <% }%>


                            <tr>
                                <td style="color:<%out.print(fontColor);%>;height: 50px;" colspan="<%= (inclPredictedDayMatrix.getCols() + 1)%>" >
                                    <b>Reality </b></td>
                            </tr>


                            <tr>
                                <td style="color:<%out.print(fontColor);%>;font-size:12px;"><b><%out.print(listLabelsRow.get(listLabelsRow.size() - 1));%></b></td>
                                        <% int rowPredicted = inclPredictedDayMatrix.getRows() - 1;
                                            ArrayList<Integer> listRealityValues = new ArrayList<Integer>();

                                            for (int mCol = 0; mCol < inclPredictedDayMatrix.getCols(); mCol++) {
                                                listRealityValues.add((int) inclPredictedDayMatrix.getValue(rowPredicted, mCol));
                                                int indexPredicted = (int) listRealityValues.get(mCol);

                                                Double originalValue = Double.NaN;
                                                if (inclPredictedDayMatrix.getOriginalValue(rowPredicted, mCol) != Double.NEGATIVE_INFINITY) {
                                                    originalValue = inclPredictedDayMatrix.getOriginalValue(rowPredicted, mCol);
                                                }
                                                Color colorCell = null;
                                                if (indexPredicted >= 0) {
                                                    colorCell = colorScaleCell[255 - indexPredicted];
                                                } else {
                                                    colorCell = Color.gray;
                                                }
                                                if (originalValue.isNaN() && colorCell != Color.gray) {

                                                    originalValue = Operations.minmax((indexPredicted) * 1.0, 0.0, 255.0, inclPredictedDayMatrix.getMinValue(), inclPredictedDayMatrix.getMaxValue());
                                                }
                                                boolean interpolatedFlag = inclPredictedDayMatrix.getFlag(rowPredicted, mCol);

                                                int red2 = colorCell.getRed();
                                                int green2 = colorCell.getGreen();
                                                int blue2 = colorCell.getBlue();

                                        %>
                                <td title="<%out.print(predictedEndDate + "\n" + listLabelsCol.get(mCol) + " \n" + "Orig. Value: " + originalValue);%>" 
                                    style="background-color: rgb(<%out.print(red2);%>,<%out.print(green2);%>,<%out.print(blue2);%>);color:rgb(<%out.print(red2);%>,<%out.print(green2);%>,<%out.print(blue2);%>);  
                                    <%if (interpolatedFlag == true) {
                                    %>
                                    border: 1px solid red;
                                    <%}%>"
                                    width="<%out.print(sizeCellWidth);%>px" height="<%out.print(sizeCellHeight);%>px"
                                    >

                                </td>
                                <% }%>
                            </tr>
                            <tr>
                                <td style="color:<%out.print(fontColor);%>;height: 50px;" colspan="<%= (inclPredictedDayMatrix.getCols() + 1)%>" ><b>Prediction - <%out.print(techniquePrediction);%></b></td>
                            </tr>
                            <%

                                ArrayList<Integer> listPredictionValues = new ArrayList<Integer>();

                                for (int mCol = 0; mCol < inclPredictedDayMatrix.getCols(); mCol++) {//numberExistingCols; mCol++) {
                                    int indexPredicted = -1;
                                    Instance testExample = new Instance(3);
                                    if (techniquePrediction.equals("linearRegression")) {

                                        testExample.setValue((Attribute) fvWekaAttributes.elementAt(0), rowPredicted);
                                        testExample.setValue((Attribute) fvWekaAttributes.elementAt(1), mCol);
                                        LinearRegression linearmodel = (LinearRegression) listModels.get(mCol);
                                        indexPredicted = (int) linearmodel.classifyInstance(testExample);
                                    } else {
                                        if (techniquePrediction.equals("isotonicRegression")) {

                                            testExample.setValue((Attribute) fvWekaAttributes.elementAt(0), rowPredicted);
                                            testExample.setValue((Attribute) fvWekaAttributes.elementAt(1), mCol);
                                            IsotonicRegression isomodel = (IsotonicRegression) listModels.get(mCol);
                                            indexPredicted = (int) isomodel.classifyInstance(testExample);
                                        } else {

                                            if (techniquePrediction.equals("gaussianProcesses")) {
                                                testExample.setValue((Attribute) fvWekaAttributes.elementAt(0), rowPredicted);
                                                testExample.setValue((Attribute) fvWekaAttributes.elementAt(1), mCol);
                                                GaussianProcesses gaumodel = (GaussianProcesses) listModels.get(mCol);
                                                indexPredicted = (int) gaumodel.classifyInstance(testExample);
                                            }
                                        }

                                    }

                                    if (indexPredicted > 255) {
                                        indexPredicted = 255;
                                    }
                                    listPredictionValues.add(indexPredicted);
                                }

                            %>
                            <tr>
                                <td style="color:<%out.print(fontColor);%>;font-size:12px;"><b><%out.print(listLabelsRow.get(listLabelsRow.size() - 1));%></b></td>
                                        <%
                                            for (int mCol = 0; mCol < listPredictionValues.size(); mCol++) {
                                                int indexPredicted = -1;
                                                indexPredicted = listPredictionValues.get(mCol);
                                                Double originalValue = Double.NaN;
                                                if (indexPredicted != -1) {
                                                    originalValue = utils.Util.round(Operations.minmax(indexPredicted * 1.0, 0.0, 255.0, inclPredictedDayMatrix.getMinValue(), inclPredictedDayMatrix.getMaxValue()), 2);
                                                }

                                                Color colorCell = null;
                                                if (indexPredicted >= 0) {
                                                    colorCell = colorScaleCell[255 - indexPredicted];
                                                } else {
                                                    colorCell = Color.gray;
                                                }

                                                int red2 = colorCell.getRed();
                                                int green2 = colorCell.getGreen();
                                                int blue2 = colorCell.getBlue();

                                        %>
                                <td title="<%out.print(predictedEndDate + "\n" + listLabelsCol.get(mCol) + " \n" + "Orig. Value: " + originalValue);%>" 
                                    style="background-color: rgb(<%out.print(red2);%>,<%out.print(green2);%>,<%out.print(blue2);%>); 
                                    color:rgb(<%out.print(red2);%>,<%out.print(green2);%>,<%out.print(blue2);%>);  
                                    "
                                    width="<%out.print(sizeCellWidth);%>px" height="<%out.print(sizeCellHeight);%>px">

                                </td>
                                <% }
                                %>
                            </tr>
                            <tr>
                                <% /*float distance = Operations.distanceRealityPrediction(listPredictionValues, listReality);
                                     float maxPossibleValue = 256 * inclPredictedDayMatrix.getCols();
                                     float percentage = 100 - Operations.percentage(distance, maxPossibleValue);*/
                                    double similarity = Operations.pearson(listPredictionValues, listRealityValues);

                                    double percentageSimilarity = Math.round(similarity * 10000);
                                    percentageSimilarity /= 10000;
                                %>
                                <td style="color:<%out.print(fontColor);%>;height: 50px;" colspan="<%= (inclPredictedDayMatrix.getCols() + 1)%>" >
                                    Correlation: <%out.print(percentageSimilarity);%> 
                                </td>

                            </tr>

                        </table>
                    </td>



                </tr>
            </table>

        </td>

    </tr>

</table>
<%}%>