<%-- 
    Document   : EvaluationResults
    Created on : Apr 14, 2017, 7:49:03 PM
    Author     : aurea
--%>
<%@page import="utils.Util"%>
<%@page import="classification.RulesPartClassifier"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.HashSet"%>
<%@page import="classification.LinearRegressionRegression"%>
<%@page import="classification.MultilayerPerceptronClassifier"%>
<%@page import="classification.SupportVectorMachineClassifier"%>
<%@page import="classification.J48DecisionTreeClassifier"%>
<%@page import="classification.Classifier"%>
<%@page import="weka.core.Instance"%>
<%@page import="weka.core.Instances"%>
<%@page import="weka.core.Attribute"%>
<%@page import="weka.core.FastVector"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="categorization.CategorizationObject"%>
<%@page import="java.util.ArrayList"%>



<%
    String calculateResultsBoolean = (String) request.getParameter("calculateResultsBoolean");
    ArrayList<TimeInterval> listTimeIntervalAttributes_r = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (calculateResultsBoolean != null && calculateResultsBoolean.equals("true") && listTimeIntervalAttributes_r != null) {
        Integer idAttributeTarget_r = (Integer) session.getAttribute("idAttributeTarget");
        String categorizationId_r = (String) session.getAttribute("categorizationId");

        //categorization 
        ArrayList<CategorizationObject> listCategorization_r = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
        CategorizationObject categorization_r = listCategorization_r.get(Integer.valueOf(categorizationId_r));

        //preparing matrix of values 
        ArrayList<ArrayList<Double>> matrixValues = new ArrayList<ArrayList<Double>>();
        ArrayList<String> listClassificationClasses = new ArrayList<String>();
        ArrayList<String> listRegressionClasses = new ArrayList<String>();

        ArrayList<Integer> selectedAttributeSubset_r = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
        int numberCols_r = 0;
        int numberRows_r = 0;
        int vectorSize_r = 0;
        if (!selectedAttributeSubset_r.isEmpty()) {

            numberRows_r = listTimeIntervalAttributes_r.get(selectedAttributeSubset_r.get(0)).getMatrix().getRows();
            numberCols_r = listTimeIntervalAttributes_r.get(selectedAttributeSubset_r.get(0)).getMatrix().getCols();
            vectorSize_r = selectedAttributeSubset_r.size();

        }
        HashSet<String> classHashSet = new HashSet<String>();
        for (int countRows = 0; countRows < numberRows_r; countRows++) {
            for (int countCols = 0; countCols < numberCols_r; countCols++) {
                ArrayList<Double> rowValues = new ArrayList<Double>();
                boolean nanBool = false;

                for (int countSelectedAttributes = 0; countSelectedAttributes < selectedAttributeSubset_r.size(); countSelectedAttributes++) {
                    Double value = listTimeIntervalAttributes_r.get(selectedAttributeSubset_r.get(countSelectedAttributes)).getMatrix().getOriginalValue(countRows, countCols);
                    if (!value.isNaN()) {
                        rowValues.add(value);
                    } else {
                        nanBool = true;
                        rowValues.add(Double.MIN_VALUE);
                    }

                }

                Double categorizationValue = listTimeIntervalAttributes_r.get(idAttributeTarget_r).getMatrix().getOriginalValue(countRows, countCols);

                if (categorizationValue.isNaN()) {
                    nanBool = true;
                }

                if (nanBool == false) {

                    Double categorizationValueDouble = Util.round(categorizationValue,2);
                    Float categorizationValueFloat =  Float.valueOf(categorizationValueDouble.toString());
                    Float classValue = categorization_r.calculateClass(categorizationValueFloat);

                    listClassificationClasses.add(classValue.toString());
                    listRegressionClasses.add(categorizationValueDouble.toString());
                    classHashSet.add(classValue.toString());
                    matrixValues.add(rowValues);

                }

            }
        }
        // file to pass to Weka
        Instances classificationDataInstances = null;
        int numberClassificationAttributes = selectedAttributeSubset_r.size() + 1;

        FastVector fvClassificationAttributes = new FastVector(numberClassificationAttributes);
        for (int i = 0; i < selectedAttributeSubset_r.size(); i++) {
            String attributeName = i + "_" + listTimeIntervalAttributes_r.get(selectedAttributeSubset_r.get(i)).getNameAttribute();
            Attribute wekaAttribute = new Attribute(attributeName, i);
            fvClassificationAttributes.addElement(wekaAttribute);
        }

        FastVector fvClassificationClassVal = new FastVector(classHashSet.size());
        for (String s : classHashSet) {
            fvClassificationClassVal.addElement(s);
        }

        //instances
        Instances classifierDataInstances = null;
        Attribute classifierClassAttribute = new Attribute("classClassification", fvClassificationClassVal);
        fvClassificationAttributes.addElement(classifierClassAttribute);
        classifierDataInstances = new Instances("Rel", fvClassificationAttributes, matrixValues.size());

        for (int i = 0; i < matrixValues.size(); i++) {

            // Create the instance
            int instanceSize = matrixValues.get(i).size() + 1;
            Instance iExample = new Instance(instanceSize);
            int j = 0;
            for (j = 0; j < matrixValues.get(i).size(); j++) {
                iExample.setValue((Attribute) fvClassificationAttributes.elementAt(j), matrixValues.get(i).get(j));
            }
            iExample.setValue((Attribute) fvClassificationAttributes.elementAt(j), listClassificationClasses.get(i));
            // add the instance
            classifierDataInstances.add(iExample);

        }
        Instances regressionDataInstances = null;
        int numberRegressionAttributes = selectedAttributeSubset_r.size() + 1;

        FastVector fvRegressionAttributes = new FastVector(numberRegressionAttributes);
        for (int i = 0; i < selectedAttributeSubset_r.size(); i++) {
            String attributeName = i + "_" + listTimeIntervalAttributes_r.get(selectedAttributeSubset_r.get(i)).getNameAttribute();
            Attribute wekaAttribute = new Attribute(attributeName, i);
            fvRegressionAttributes.addElement(wekaAttribute);
        }

        FastVector fvRegressionClassVal = new FastVector(classHashSet.size());
        for (String s : classHashSet) {
            fvRegressionClassVal.addElement(s);
        }

        Attribute regressionClassAttribute = new Attribute("classRegression");
        fvRegressionAttributes.addElement(regressionClassAttribute);
        regressionDataInstances = new Instances("Rel", fvRegressionAttributes, matrixValues.size());
        for (int i = 0; i < matrixValues.size(); i++) {

            // Create the instance
            int instanceSize = matrixValues.get(i).size() + 1;
            Instance iExample = new Instance(instanceSize);
            int j = 0;
            for (j = 0; j < matrixValues.get(i).size(); j++) {

                iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), matrixValues.get(i).get(j));
            }

            iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), Double.valueOf(listRegressionClasses.get(i)));
            // add the instance
            regressionDataInstances.add(iExample);
        }

        //classification 
        double j48Result = 0.0;
        double svmResult = 0.0;//support vector machine
        double mpResult = 0.0;//multilayer perceptron
        double lrResult = 0.0;//linear regression
        String rulesPartResult ="";
         String rulesJ48Result ="";
        Classifier typeClassifier = null;

        
         //RulesPart
        typeClassifier = null;
        typeClassifier= new RulesPartClassifier();
        rulesPartResult = typeClassifier.classify(classifierDataInstances);
        
        
        //J48
        typeClassifier = null;
        typeClassifier = new J48DecisionTreeClassifier();
        j48Result = typeClassifier.resultClassify(classifierDataInstances);
        j48Result = Math.round(j48Result * 1000.0) / 1000.0;
        rulesJ48Result = typeClassifier.classify(classifierDataInstances);

        //support vector machine
        typeClassifier = null;
        typeClassifier = new SupportVectorMachineClassifier();
        svmResult = typeClassifier.resultClassify(classifierDataInstances);
        svmResult = Math.round(svmResult * 1000.0) / 1000.0;
        

        //multilayer perceptron
        typeClassifier = null;
        typeClassifier = new MultilayerPerceptronClassifier();
        mpResult = typeClassifier.resultClassify(classifierDataInstances);
        mpResult = Math.round(mpResult * 1000.0) / 1000.0;

        //linear regression
        typeClassifier = null;
        typeClassifier = new LinearRegressionRegression();
        lrResult = typeClassifier.resultClassify(regressionDataInstances);
        lrResult = Math.round(lrResult * 1000.0) / 1000.0;

%>

<tr>
    <td style="width: 250px; color: black;">
        <label style="width: 250px; text-align: right;">J48 accuracy: </label>

    </td>
    <td style="width: 70px;color: black;">
        <input id="resultJ48Input" style="width: 70px;text-align: right;" type="text" disabled="disabled" width="70px" value="<%=j48Result%>">
    </td>
</tr>
<tr>
    <td style="width: 250px;color: black;">
        <label style="width: 250px; text-align: right;">
            Support Vector Machine accuracy:</label>
    </td>
    <td style="width: 70px;color: black;">
        <input id="resultSVMInput" style="width: 70px;text-align: right;" width="70px"  type="text" disabled="disabled" value="<%=svmResult%>">
    </td>
</tr>
<tr>
    <td style="width: 250px;color: black;">
        <label style="width: 250px; text-align: right;">
            Multilayer Perceptron accuracy: </label>
    </td>
    <td style="width: 70px;color: black;">
        <input id="resultMPInput" style="width: 70px;text-align: right;" width="70px" type="text" disabled="disabled" value="<%=mpResult%>">
    </td>
</tr>
<tr>
    <td style="width: 250px;color: black;">
        <label style="width: 250px; text-align: right;">
            Linear Regression correlation:</label>
    </td>
    <td style="width: 70px;color: black;">
        <input id="resultLRInput" style="width: 70px;text-align: right;" width="70px" type="text" disabled="disabled" value="<%=lrResult%>" >
    </td>
</tr>

<tr><td colspan="2">
    <textarea rows="10" cols="60">
<%=rulesPartResult%>
</textarea>
</td>
</tr>
<tr><td colspan="2">
    <textarea rows="10" cols="60">
<%=rulesJ48Result%>
</textarea>
</td>
</tr>

<%}%>
