<%-- 
    Document   : EvaluationResult
    Created on : Mar 1, 2016, 8:23:28 PM
    Author     : aurea
--%>

<%@page import="java.util.HashSet"%>
<%@page import="weka.core.Instance"%>
<%@page import="weka.core.Instances"%>
<%@page import="weka.core.Attribute"%>
<%@page import="weka.core.FastVector"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="categorization.CategorizationObject"%>
<%@page import="utils.Operations"%>
<%@page import="utils.Util"%>
<%@page import="java.util.Collections"%>
<%@page import="classification.SimpleLinearRegressionRegression"%>
<%@page import="classification.LinearRegressionRegression"%>
<%@page import="classification.SupportVectorMachineClassifier"%>
<%@page import="classification.MultilayerPerceptronClassifier"%>
<%@page import="java.util.List"%>
<%@page import="classification.J48DecisionTreeClassifier"%>
<%@page import="classification.Classifier"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%
    ConnectionXMLReader connectionXMLReader = (ConnectionXMLReader) session.getAttribute("connectionXMLReader");
    String subsetAttributesSelected = (String) request.getParameter("subsetAttributesSelected");
    String subsetAttributesSelectedArray[] = subsetAttributesSelected.split(",");

    String arraySelectedAttributes = "";
    for (int j = 0; j < subsetAttributesSelectedArray.length; j++) {
        String name = subsetAttributesSelectedArray[j].split("-")[0];
        arraySelectedAttributes += "'" + name + "'";
        if (j < subsetAttributesSelectedArray.length - 1) {
            arraySelectedAttributes += ",";
        }
    }

    String techniqueEvaluation = (String) request.getParameter("techniqueEvaluation");
    String evaluationOption = (String) request.getParameter("evaluationOption");
    String categorizationId = (String) request.getParameter("categorization");
    String attributeTarget = (String) request.getParameter("attributeTarget");
    String normalizedData = (String) request.getParameter("normalizedData");

    //for connection
    String driver = (String) session.getAttribute("driver");
    String url = (String) session.getAttribute("url");
    String username = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    //for query
    ArrayList<String> completeListSource1 = (ArrayList<String>) session.getAttribute("completeListSource1");
    String source2 = (String) session.getAttribute("source2");

    String fromDateStr = (String) session.getAttribute("fromDateStr");
    String toDateStr = (String) session.getAttribute("toDateStr");
    //String intervalTimes = (String) session.getAttribute("intervalTimes");
    //String intervalTimesArray[] = intervalTimes.split(",");
    String valueThreshold = (String) session.getAttribute("valueThreshold");

    //categorization 
    ArrayList<CategorizationObject> listCategorization1 = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
    CategorizationObject categorization = null;
    if (!categorizationId.equals("select")) {
        categorization = listCategorization1.get(Integer.valueOf(categorizationId));
    }

    //preparing matrix of values 
    ArrayList<ArrayList<Double>> matrixValues = new ArrayList<ArrayList<Double>>();
    ArrayList<String> listClassificationClasses = new ArrayList<String>();
    ArrayList<String> listRegressionClasses = new ArrayList<String>();
    HashSet<String> classHashSet = new HashSet<String>();

    //max and min to normalize data
    List<Double> listMaxValueByAttribute = new ArrayList<Double>(java.util.Collections.nCopies(subsetAttributesSelectedArray.length, Double.MIN_VALUE));

    List<Double> listMinValueByAttribute = new ArrayList<Double>(java.util.Collections.nCopies(subsetAttributesSelectedArray.length, Double.MAX_VALUE));

    for (int elemSource1 = 0; elemSource1 < completeListSource1.size(); elemSource1++) {
        try {

            String nameFunction = "";
            if (connectionXMLReader.getDataByTimeInterval() != null && !connectionXMLReader.getDataByTimeInterval().equals("")) {
                nameFunction = connectionXMLReader.getDataByTimeInterval();
            } else {
                nameFunction = connectionXMLReader.getDataByTimeIntervalThreshold();
            }

            String queryDataToEvaluate = QueryBuilder.getDataByIntervalDates(nameFunction, arraySelectedAttributes, attributeTarget, source2,
                    String.valueOf(completeListSource1.get(elemSource1)), fromDateStr, toDateStr, valueThreshold);

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultDataToEvaluateSet = null;
            Class.forName(driver).newInstance();
            connection = DriverManager.getConnection(url, username, password);
            preparedStatement = connection.prepareStatement(queryDataToEvaluate);
            resultDataToEvaluateSet = preparedStatement.executeQuery();

            while (resultDataToEvaluateSet.next()) {
                ArrayList<Double> rowValues = new ArrayList<Double>();
                String round = resultDataToEvaluateSet.getString("valuesattributes");

                String[] valuesattributes = round.replace("{", "").replace("}", "").split(",");

                for (int j = 0; j < valuesattributes.length; j++) {
                    Double value = Double.valueOf(valuesattributes[j]);
                    if (value > listMaxValueByAttribute.get(j)) {
                        listMaxValueByAttribute.set(j, value);
                    }
                    if (value < listMinValueByAttribute.get(j)) {
                        listMinValueByAttribute.set(j, value);
                    }
                    rowValues.add(value);

                }
                String valueClassification = resultDataToEvaluateSet.getString("valueclassificationattribute");
                Double valueCategorization = (Double) Util.round(Double.valueOf(valueClassification), 2);
                Float valueCategorizatioFloat = (Float) Float.valueOf(valueClassification);

                if (categorization != null) {
                    Float classValue = categorization.calculateClass(valueCategorizatioFloat);

                    listClassificationClasses.add(classValue.toString());
                    classHashSet.add(classValue.toString());
                } else {
                    listRegressionClasses.add(valueCategorization.toString());
                }

                matrixValues.add(rowValues);

            }

            connection.close();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException ex) {
            out.print("SQLException: " + ex.getMessage());
            out.print("SQLState: " + ex.getSQLState());
            out.print("VendorError: " + ex.getErrorCode());
        }

    }
    // file to pass to Weka
    int numberWekaAttributes = subsetAttributesSelectedArray.length + 1;

    FastVector fvWekaAttributes = new FastVector(numberWekaAttributes);
    for (int i = 0; i < subsetAttributesSelectedArray.length; i++) {
        Attribute wekaAttribute = new Attribute(subsetAttributesSelectedArray[i], i);
        fvWekaAttributes.addElement(wekaAttribute);
    }

    FastVector fvClassVal = new FastVector(classHashSet.size());
    for (String s : classHashSet) {
        fvClassVal.addElement(s);
    }

 

    //instances
    Instances dataInstances = null;

    //with normalized data
    if (normalizedData.equals("true")) {
        if (evaluationOption.equals("classification")) {
            System.out.println(evaluationOption + " " + techniqueEvaluation + " normalized");
            Attribute ClassAttribute = new Attribute("classClassificationNorm", fvClassVal);
            fvWekaAttributes.addElement(ClassAttribute);
            dataInstances = new Instances("Rel", fvWekaAttributes, matrixValues.size());

            // Create instances set
            for (int i = 0; i < matrixValues.size(); i++) {
                // Create the instance
                int instanceSize = matrixValues.get(i).size() + 1;
                Instance iExample = new Instance(instanceSize);

                int j = 0;
                for (j = 0; j < matrixValues.get(i).size(); j++) {
                    Double normalizedValue = Operations.minmax(matrixValues.get(i).get(j), listMinValueByAttribute.get(j), listMaxValueByAttribute.get(j), 0.0, 1.0);
                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), normalizedValue);
                }

                iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), listClassificationClasses.get(i));
                // add the instance
                dataInstances.add(iExample);
            }
        } else {
            if (evaluationOption.equals("regression")) {
                System.out.println(evaluationOption + " " + techniqueEvaluation + " normalized");
                Attribute ClassAttribute = new Attribute("classRegressionNorm");
                fvWekaAttributes.addElement(ClassAttribute);
                dataInstances = new Instances("Rel", fvWekaAttributes, matrixValues.size());

                for (int i = 0; i < matrixValues.size(); i++) {
                    // Create the instance
                    int instanceSize = matrixValues.get(i).size() + 1;
                    Instance iExample = new Instance(instanceSize);
                    int j = 0;
                    for (j = 0; j < matrixValues.get(i).size(); j++) {
                        Double normalizedValue = Operations.minmax(matrixValues.get(i).get(j), listMinValueByAttribute.get(j), listMaxValueByAttribute.get(j), 0.0, 1.0);
                        iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), normalizedValue);
                    }
                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), Double.valueOf(listRegressionClasses.get(i)));
                    // add the instance
                    dataInstances.add(iExample);
                }
            }
        }
    } else {

        if (evaluationOption.equals("classification")) {
            System.out.println(evaluationOption + " " + techniqueEvaluation + " not normalized");
            Attribute ClassAttribute = new Attribute("classClassification", fvClassVal);
            fvWekaAttributes.addElement(ClassAttribute);
            dataInstances = new Instances("Rel", fvWekaAttributes, matrixValues.size());

            for (int i = 0; i < matrixValues.size(); i++) {

                // Create the instance
                int instanceSize = matrixValues.get(i).size() + 1;
                Instance iExample = new Instance(instanceSize);
                int j = 0;
                for (j = 0; j < matrixValues.get(i).size(); j++) {
                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), matrixValues.get(i).get(j));
                }
                iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), listClassificationClasses.get(i));
                // add the instance
                dataInstances.add(iExample);

            }
        } else {
            if (evaluationOption.equals("regression")) {
                System.out.println(evaluationOption + " " + techniqueEvaluation + " with not  normalized data");
                Attribute ClassAttribute = new Attribute("classRegression");
                fvWekaAttributes.addElement(ClassAttribute);
                dataInstances = new Instances("Rel", fvWekaAttributes, matrixValues.size());
                for (int i = 0; i < matrixValues.size(); i++) {

                    // Create the instance
                    int instanceSize = matrixValues.get(i).size() + 1;
                    Instance iExample = new Instance(instanceSize);
                    int j = 0;
                    for (j = 0; j < matrixValues.get(i).size(); j++) {

                        iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), matrixValues.get(i).get(j));
                    }

                    iExample.setValue((Attribute) fvWekaAttributes.elementAt(j), Double.valueOf(listRegressionClasses.get(i)));
                    // add the instance
                    dataInstances.add(iExample);
                }
            }
        }
    }

    //classification 
    String resultClassification = "";
    Classifier typeClassifier = null;

    if (techniqueEvaluation.equals("J48")) {
        typeClassifier = null;
        typeClassifier = new J48DecisionTreeClassifier();
        resultClassification = typeClassifier.classify(dataInstances);

    } else {
        if (techniqueEvaluation.equals("MultilayerPerceptron")) {
            typeClassifier = null;
            typeClassifier = new MultilayerPerceptronClassifier();
            resultClassification = typeClassifier.classify(dataInstances);

        } else {
            if (techniqueEvaluation.equals("SupportVecorMachine")) {
                typeClassifier = null;
                typeClassifier = new SupportVectorMachineClassifier();
                resultClassification = typeClassifier.classify(dataInstances);
            } else {
                if (techniqueEvaluation.equals("LinearRegression")) {
                    typeClassifier = null;
                    typeClassifier = new LinearRegressionRegression();
                    resultClassification = typeClassifier.classify(dataInstances);
                } else {
                    if (techniqueEvaluation.equals("SimpleLinearRegression")) {
                        typeClassifier = null;
                        typeClassifier = new SimpleLinearRegressionRegression();
                        resultClassification = typeClassifier.classify(dataInstances);
                    } else {
                        typeClassifier = null;
                    }
                }
            }
        }
    }

%>

<textarea rows="18" cols="40" name="successMessage"  id="successMessage" disabled style="text-align: center; color: black;" >
    <% out.println(
                "Evaluation was successfully processed.");
        out.println(subsetAttributesSelectedArray.length
                + " attributes used.");
        out.println(resultClassification);
    %>
</textarea>