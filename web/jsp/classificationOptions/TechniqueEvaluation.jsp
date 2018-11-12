<%-- 
    Document   : TechniqueEvaluation
    Created on : Mar 1, 2016, 6:13:11 PM
    Author     : aurea
--%>

<%
    String strategyEvaluation = request.getParameter("strategyEvaluation");
    if (strategyEvaluation != null) {

        if (strategyEvaluation.equals("classification")) {
%>
<select name="selectTechniqueEvaluation" id="selectTechniqueEvaluation"   style="width: 160px" onchange="clearMessage()">
    <option value="select">Select...</option>
    <option value="J48">J48</option>
     <option value="MultilayerPerceptron">Multilayer Perceptron</option>
     <!--option value="SupportVectorMachine">Support Vector Machine</option-->
</select>
<%} else {
    if (strategyEvaluation.equals("regression")) {
%>
<select name="selectTechniqueEvaluation" id="selectTechniqueEvaluation"   style="width: 160px" onchange="clearMessage()" >
    <option value="select">Select...</option>
    <option value="LinearRegression">Linear Regression</option>
     <option value="SimpleLinearRegression">Simple Linear Regression</option>
</select>
<%} else {
%><select name="selectTechniqueEvaluation" id="selectTechniqueEvaluation"   style="width: 160px" onchange="clearMessage()" >
    <option value="select">Select...</option>
</select>
<%}
    }

} else {
%>
<select name="selectTechniqueEvaluation" id="selectTechniqueEvaluation"   style="width: 160px" onchange="clearMessage()">
    <option value="select">Select...</option>
</select>
<%}%>