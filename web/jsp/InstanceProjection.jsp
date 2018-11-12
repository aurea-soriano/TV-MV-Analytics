<%-- 
    Document   : InstanceProjection
    Created on : Jun 21, 2016, 3:07:06 PM
    Author     : aurea
--%>



<%@page import="categorization.CategorizationObject"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%
    ArrayList<TimeInterval> listTimeIntervalAttributes = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalAttributes != null) {

        ConnectionXMLReader connectionXMLReader = (ConnectionXMLReader) session.getAttribute("connectionXMLReader");

        ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
        ArrayList<String> listAttributesByCluster = new ArrayList<String>();
        ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
        for (int i = 0; i < resultClustering.size(); i++) {
            String listAttributesStr = "";
            for (int j = 0; j < resultClustering.get(i).size(); j++) {
                listAttributesStr += listTimeIntervalAttributes.get(resultClustering.get(i).get(j)).getNameAttribute() + ",";
            }
            if (listAttributesStr.endsWith(",")) {
                listAttributesStr = listAttributesStr.substring(0, listAttributesStr.length() - 1);
            }
            listAttributesByCluster.add(listAttributesStr);
        }

        String messageNumberSelectedAttributes = "";
        String minTimeValue = (String) session.getAttribute("minTimeValue");
        String maxTimeValue = (String) session.getAttribute("maxTimeValue");
        String minTimeValueArray[] = minTimeValue.split("-");
        int minYear = Integer.valueOf(minTimeValueArray[0]);
        int minMonth = Integer.valueOf(minTimeValueArray[1]);
        int minDay = Integer.valueOf(minTimeValueArray[2]);
        String maxTimeValueArray[] = maxTimeValue.split("-");
        int maxYear = Integer.valueOf(maxTimeValueArray[0]);
        int maxMonth = Integer.valueOf(maxTimeValueArray[1]);
        int maxDay = Integer.valueOf(maxTimeValueArray[2]);
        String fromDateStr = (String) session.getAttribute("fromDateStr");
        String toDateStr = (String) session.getAttribute("toDateStr");
        // String intervalTimes = (String) session.getAttribute("intervalTimes");
        // String[] intervalTimesArray = intervalTimes.split(",");
        String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
        String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
        String valueThreshold = (String) session.getAttribute("valueThreshold");
        // String option = (String) session.getAttribute("option");

        String combineAllSource1DataFlag = (String) session.getAttribute("combineAllSource1DataFlag");
        ArrayList<String> completeListSource1 = (ArrayList<String>) session.getAttribute("completeListSource1");
        String source2 = (String) session.getAttribute("source2");

        ArrayList<String>   listSource1Category = (ArrayList<String>) session.getAttribute("listSource1Category");
        ArrayList<ArrayList<String>> listSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listSource1");
        ArrayList<String> listSource2 = (ArrayList<String>) session.getAttribute("listSource2");
        ArrayList<ArrayList<String>> listNameSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listNameSource1");
        ArrayList<String> listNameSource2 = (ArrayList<String>) session.getAttribute("listNameSource2");
        ArrayList<ArrayList<String>> listAttributes = (ArrayList<ArrayList<String>>) session.getAttribute("listAttributes");
        ArrayList<CategorizationObject> listCategorization = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
        String aggregationFunction = (String) session.getAttribute("aggregationFunction");

%>

<table style="width:1800px;margin:0 auto; margin:auto;text-align: center;">
    <tr>
        <td>

            <div class="well" >
                <table style="text-align:left;">

                    <tr>
                        <td>
                            <b>Attributes:</b>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <label>
                                <input type="checkbox" name="selectedAllAttributesCheckbox"  id="labelAllAttributesCheckbox"   value="SelectAllAttributes" onclick="checkAllAttributesInstanceProjectionMap(this);" >
                                <span>Select All Attributes</span>
                            </label>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div style="width:230px;height:750px;overflow:auto;">

                                <%  for (int i = 0; i < resultClustering.size(); i++) {%>
                                <div class="checkbox">
                                    <label>----------------------</label><br>
                                    <label>
                                        <input type="checkbox" name="selectedClusterCheckbox" id="<%=(i + 1)%>ClusterCheckbox" 
                                               onchange="checkAttributesByClusterInstanceProjectionMap('<%=listAttributesByCluster.get(i)%>', '<%=(i + 1)%>ClusterCheckbox');
                                                       countSelectedAttributesInstanceProjectionMap();"value="<%=(i + 1)%>"

                                               >
                                        <b style="color: #398439;"><%out.print("Cluster" + (i + 1) + ": ");%></b>
                                    </label>
                                </div>
                                <%
                                    for (int j = 0; j < resultClustering.get(i).size(); j++) {
                                        String nameAttribute = listTimeIntervalAttributes.get(resultClustering.get(i).get(j)).getNameAttribute();
                                %>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="selectedAttributesCheckbox" onchange="countSelectedAttributesInstanceProjectionMap();"value="<%=nameAttribute%>"
                                               <%
                                                   int indexElemTmp = resultClustering.get(i).get(j);

                                                   if (selectedAttributesSubset.contains(indexElemTmp)) {%>
                                               checked 

                                               <%}
                                               %>  >
                                        <span <%
                                            if (selectedAttributesSubset.contains(indexElemTmp)) {%>
                                            style="color: red;"  

                                            <%}
                                            %> ><%out.print(nameAttribute);%></span>
                                    </label>
                                </div>
                                <%}
                                    }
                                %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label> <input style="width:230px;" id="numberSelectedAttributesText" type="text" disabled
                                           <% if (messageNumberSelectedAttributes != null) {
                                           %>
                                           value="<%=messageNumberSelectedAttributes%>"
                                           <%}
                                           %>
                                           ></label>
                        </td>
                    </tr>
                </table>

            </div>
        </td>
        <td style="width:1300px; border: 2;">
            <div id="instanceProjectionMapSpace"  >

            </div>
        </td>
        <td>

            <div class="well" style="height: 840px;  position:relative; " >
                <table style="width:400px;line-height: 200%">
                    <tr>
                        <td colspan="4">
                            <b>Date Range:</b>
                        </td>
                    </tr>

                    <tr>
                        <td  colspan="2" style="text-align: right;"><b>From:</b> </td>
                        <td  colspan="2" style="text-align: left;">
                            <script>
                                $(function () {
                                    $("#fromDate").datepicker({
                                        defaultDate: "today",
                                        changeMonth: true,
                                        changeYear: true,
                                        dateFormat: 'yy-mm-dd',
                                        numberOfMonths: 2,
                                        minDate: new Date(<%=minYear%>, <%=minMonth - 1%>, <%=minDay%>),
                                        maxDate: new Date(<%=maxYear%>, <%=maxMonth - 1%>, <%=maxDay%>)
                                                // onClose: function (selectedDate) {
                                                //     $("#toDate").datepicker("option", "minDate", selectedDate);
                                                //}
                                    });
                                    $("#toDate").datepicker({
                                        defaultDate: "today",
                                        changeMonth: true,
                                        changeYear: true,
                                        dateFormat: 'yy-mm-dd',
                                        numberOfMonths: 2,
                                        minDate: new Date(<%=minYear%>, <%=minMonth - 1%>, <%=minDay%>),
                                        maxDate: new Date(<%=maxYear%>, <%=maxMonth - 1%>, <%=maxDay%>)
                                                //onClose: function (selectedDate) {
                                                //    $("#fromDate").datepicker("option", "maxDate", selectedDate);
                                                // }
                                    });
                                });
                            </script> <!--min='<%//out.print(minTimeValue);%>'  max='<%//out.print(maxTimeValue);%>'-->
                            <input style="width:170px" type="text" id='fromDate' name='fromDate'   onchange='clearMessage();'  
                                   <%
                                       if (fromDateStr != null) {%>
                                   value="<%out.print(fromDateStr);%>"  
                                   <% }

                                   %>
                                   ></td>
                    </tr><tr>
                        <td colspan="2" style="text-align: right;"><b>To:</b> </td>
                        <td colspan="2" style="text-align: left;">      <!--min='<%//out.print(minTimeValue);%>'  max='<%//out.print(maxTimeValue);%>'-->
                            <input style="width:170px" type="text" id='toDate' name='toDate'   onchange='clearMessage();' 
                                   <%
                                       if (toDateStr != null) {%>
                                   value="<%out.print(toDateStr);%>"  
                                   <% }%>></td>



                        <% if (connectionXMLReader.getInstanceThresholdAttributeName() != null
                                    && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {%>
                    <tr>
                        <td colspan="2" style="text-align: right; "><b><%out.print("Minimum " + connectionXMLReader.getInstanceThresholdAttributeName() + ":");%></b></td>
                        <td colspan="2" style="text-align: left;">  
                            <select name="valueThreshold" id="valueThreshold"  disabled="disabled"  style="width: 170px;" onchange="clearMessage();">
                                <%
                                    ArrayList<String> listThresholdValues = connectionXMLReader.getListThresholdValues();
                                    for (int aux = 0; aux < listThresholdValues.size(); aux++) {
                                %>
                                <option value="<%=listThresholdValues.get(aux)%>"
                                        <%if (valueThreshold != null && valueThreshold.equals(listThresholdValues.get(aux))) {%>
                                        selected<%}%>><%out.print(listThresholdValues.get(aux));%></option>
                                <%
                                    } %>
                            </select>
                        </td>
                    </tr>
                    <%} %>
                    <%if (connectionXMLReader.getSource2TableName() != null && !connectionXMLReader.getSource2TableName().equals("")) {%>
                    <tr> <td colspan="2" style="text-align: right; "><b><%out.print(connectionXMLReader.getSource2TableName() + ":");%></b></td>
                        <td colspan="2" style="text-align: left;">  
                            <select name="selectListSource2" id="selectListSource2" disabled="disabled"    style="width: 170px" onchange="clearMessage();">
                                <% for (int aux = 0; aux < listSource2.size(); aux++) {
                                %>
                                <option value="<%out.print(listSource2.get(aux));%>"  <%
                                    if (source2 != null && source2.equals(listSource2.get(aux))) {%>
                                        selected
                                        <%}
                                        %>

                                        ><%out.print(listNameSource2.get(aux));%></option>
                                <%}
                                %>
                            </select></td>
                    </tr>
                    <%}%>

                    <tr> <td colspan="2" style="text-align: right; "><b>Combine all <%out.print(connectionXMLReader.getSource1TableName());%> data?:</b></td>
                        <td colspan="2" style="text-align: left;">  
                            <input type="checkbox" name="combineAllSource1DataCheckbox" disabled="disabled"  id="combineAllSource1DataCheckbox"   
                                   onclick="combineAllSource1Data(this);"

                                   <%if (combineAllSource1DataFlag != null && combineAllSource1DataFlag.equals("true")) {%>
                                   checked
                                   <%}%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: right; "><b><%out.print(connectionXMLReader.getSource1TableName() + ":");%></b></td>
                        <td colspan="2" style="text-align: left; ">
                        <select multiple="multiple" id="selectListSource1" name="selectListSource1"  style="color: white">
                                    <% for (int countSource1Category = 0; countSource1Category < listSource1Category.size(); countSource1Category++) {
                                    %>
                                    <optgroup class="group selected" label="<%out.print(listSource1Category.get(countSource1Category));%>"
                                              >
                                        <% for (int countSource1 = 0; countSource1 < listSource1.get(countSource1Category).size(); countSource1++) {
                                                String source1SelectId = listSource1.get(countSource1Category).get(countSource1);
                                                String source1SelectName = listNameSource1.get(countSource1Category).get(countSource1);

                                        %>
                                        <option value="<%out.print(source1SelectId);%>"
                                                <%if (completeListSource1.contains(source1SelectId)) {%>
                                                selected
                                                <%}%>
                                                ><%out.print(source1SelectName);%></option>
                                        <%}
                                        %>
                                    </optgroup>
                                    <%}
                                    %>
                                </select>
                                <script>
                                    $("#selectListSource1").multipleSelect({
                                        width: 200,
                                        multiple: true,
                                        multipleWidth: 500

                                    });
                                </script>    
                            
                            
                            
                            </td>
                    </tr>


                    <tr>
                        <td style="text-align: right;" colspan="2"><b>Attribute Target:</b></td><td style="text-align: left;" colspan="2">
                            <select  id="selectListAttribute" name="selectListAttribute"  style="color: black;width: 170px;">
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
                    <tr>  
                        <td style="text-align: right;"  colspan='2' > 
                            <div><b>Categorization:</b></div>
                        </td>
                        <td style="text-align: left;"  colspan='2'>
                            <select  id="selectListCategorization" name="selectListCategorization"  style="color: black;width: 170px;" onchange="loadDescriptionCategorizationInstanceProjection();">
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
                        <td colspan='4' style='text-align:right;'> <div id='descriptionCategorizationContent'></div>
                        </td>
                    </tr>

                  
                    <tr>
                        <td style="text-align: right;" colspan="2"><b>Color by:</b></td>
                        <td style="text-align: left;" colspan="2">  
                            <select name="listColorBy" id="listColorBy"  style="width: 170px">
                                <option value="categorized">Categorized</option>
                                <option value="continuous">Continuous</option>
                            </select>
                        </td>
                    </tr>
                    <tr>


                        <td style="text-align: right; " colspan="2"><b>Projection:</b></td>
                        <td style="text-align: left;" colspan="2">   <select name="selectProjection" id="selectProjection"    style="width: 170px" 
                                                                             >
                                <option value="LSP">LSP - Paulovich</option>
                                <option value="ProjClusProjection">ProjClusProjection-Paulovich</option>
                                <option value="FastMapProjection">FastMap-Faloutsos</option>
                                <option value="ForceSchemeProjection">Force Scheme-Tejada</option>
                                <option value="IDMAPProjection">IDMAP -Minghim</option>

                            </select></td>
                    </tr>
                    <tr>


                        <td style="text-align: right; " colspan="2"><b>Strategy:</b></td>
                        <td style="text-align: left;" colspan="2">   <select name="selectStrategyProjection" 
                                                                             id="selectStrategyProjection"    style="width: 170px;">
                                <option value="non-hierarchical">Non-hierarchical</option>
                                <option value="hierarchical">Hierarchical</option>

                            </select></td>
                    </tr>

                    <tr>
                        <td colspan='4' style='text-align:center;'>

                            <button  id="createInstanceProjectionButton" name="createInstanceProjectionButton"  type="button"  onclick="
                                    createInstanceProjectionMap(null, '<%out.print(connectionXMLReader.getInstanceThresholdAttributeName());%>',
                                            '<%out.print(connectionXMLReader.getSource1TableName());%>',
                                            '<%out.print(connectionXMLReader.getSource2TableName());%>'
                                            );"><b>Project</b></button>
                        </td>

                    </tr>
                    <tr>
                        <td colspan='4' style='text-align:right;'>
                            <textarea rows="2" cols="25" name="successMessage"  id="successMessage" disabled style="text-align: center; color: black;" >
                            </textarea></td>
                    </tr>

                </table>
                <br>
                <br>
            </div>
        </td>

    </tr>
</table>



<%
} else {
%>

<br>
<br>
<table style="text-align: center; margin:0 auto; margin:auto;">
    <tr>
        <td>


            <div class="col-sm-12">

                Error with the query.
            </div>
        </td>
    </tr>
</table>
<%
    }%>