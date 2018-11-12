<%-- 
    Document   : EvaluationSubsetAttributes
    Created on : Mar 1, 2016, 3:59:40 PM
    Author     : aurea
--%>


<%@page import="categorization.CategorizationObject"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<String> listSelectedAttributesSubset = (ArrayList<String>) session.getAttribute("listSelectedAttributesSubset");
    if (listSelectedAttributesSubset != null) {

        ArrayList<ArrayList<String>> listAttributes = (ArrayList<ArrayList<String>>) session.getAttribute("listAttributes");
        ArrayList<CategorizationObject> listCategorization = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
%>
<br>
<div class="container-fluid" style="width:750px; height: 770px;   margin:0 auto; margin:auto;">
    <div class="row">

        <div class="col-sm-2">
            <div class="well" style="height: 770px; width: 270px; position:relative; left: 2px;">


                <div class="titled-box">

                    <div >
                        <br>
                        <div  class="form-group shiny-input-checkboxgroup shiny-input-container shiny-bound-input">


                            <div >

                                <div style="width:230px;height:770px;overflow:auto;">

                                    <td style="position: fixed;">
                                        <div id="attributes_subset_frame4" >
                                            <%@ include file="SelectedAttributesSubset.jsp" %>
                                        </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-2">
            <div class="well" style="height: 840px; width: 380px; position:relative; left:170px; " >
                <div class="row">
                    <div class="col-sm-12">
                        <div style="text-align: center;">
                            <div ><b>Model selection</b></div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <table style="width: 350px; ">
                            <tr>  
                                <td style="width:50%;text-align: right;">  <br>
                                    <div ><b>Normalized data:</b></div>
                                </td>
                                <td style="width:50%; ">  <br>
                                    <input type="checkbox" name="normalizedDataCheckbox" id="normalizedDataCheckbox">

                                </td>
                            </tr>
                            <tr>  
                                <td style="width:50%;text-align: right;">  <br>
                                    <div ><b>Strategy evaluation:</b></div>
                                </td>
                                <td style="width:50%; ">  <br>

                                    <select name="selectEvaluationOption" id="selectEvaluationOption"   onchange="clearMessage();
                                            loadTechniqueEvaluation();" style="width: 160px" >
                                        <option value="select">Select...</option>
                                        <option value="classification">Classification</option>
                                        <option value="regression">Regression</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>  
                                <td style="width:50%;text-align: right;">  <br>
                                    <div ><b>Technique evaluation:</b></div>
                                </td>
                                <td style="width:50%; ">    <br>
                                    <div id='techniqueEvaluationByEvaluationOptionContent'>

                                    </div>
                                </td>
                            </tr>


                            <tr>  
                                <td style="text-align: right;"  colspan='1' > 
                                    <br> <b>Categorization:</b>
                                </td>
                                <td style="text-align: left;"  colspan='1'><br>
                                    <select  id="selectListCategorization" name="selectListCategorization"  style="color: black;width: 160px;" onchange="loadDescriptionCategorizationInstanceProjection();">
                                        <option value="select" >Select...</option>
                                        <% for (int aux = 0; aux < listCategorization.size(); aux++) {

                                        %>
                                        <option value="<%out.print(aux);%>" ><%out.print(listCategorization.get(aux).getName());%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2' style='text-align:right;'> <br><div id='descriptionCategorizationContent'></div>
                                </td>
                            </tr>

                            <tr>
                                <td style="text-align: right;" colspan="1"><br><b>Attribute Target:</b></td>
                                <td style="text-align: left;" colspan="1"><br>
                                    <select  id="selectAttributeTarget" name="selectAttributeTarget"  style="color: black;width: 160px;">
                                        <option value="select" >Select...</option>
                                        <% for (int aux = 0; aux < listAttributes.size(); aux++) {
                                                for (int aux2 = 0; aux2 < listAttributes.get(aux).size(); aux2++) {
                                        %>
                                        <option value="<%out.print(listAttributes.get(aux).get(aux2));%>"><%out.print(listAttributes.get(aux).get(aux2));%></option>
                                        <%}
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>

                        </table>
                        <br>
                        <br>




                        <table style="width: 280px; ">
                            <tr>
                                <td colspan='2' style='text-align:center;'>
                                    <button  id="evaluateAttributesSubsetButton" name="evaluateAttributesSubsetButton"  type="button"  onclick="
                                            evaluateAttributesSubset();"><b>Evaluate</b></button>
                                </td>
                            </tr><tr>
                                <td colspan='2' style='text-align:center;'>
                                    <br>
                                    <div class="row">
                                        <div class="col-sm-12"  id="successMessageContent">

                                            <textarea rows="3" cols="35" name="successMessage"  id="successMessage" disabled style="text-align: center; color: black;" >
                                            </textarea>
                                        </div>
                                    </div>
                                    <br></td>
                            </tr>


                        </table>
                    </div>
                </div>
            </div></div>            

        <%
        } else {
        %>

        <br>
        <br>


        <div class="col-sm-12" style="text-align: center; margin:0 auto; margin:auto;">

            Error with the query.
        </div>

        <%
            }%>