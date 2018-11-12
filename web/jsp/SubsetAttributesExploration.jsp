<%-- 
    Document   : SubsetAttributesExploration
    Created on : Mar 10, 2016, 5:08:03 PM
    Author     : aurea
--%>



<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    if ((ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData") != null) {
        ArrayList<String> listSelectedAttributesSubset = (ArrayList<String>) session.getAttribute("listSelectedAttributesSubset");
%>
<br>
<div class="container-fluid" style="width:300px; height: 150px;   margin:0 auto; margin:auto;">
    <div class="row">

        <div class="col-sm-2">
            <div class="well" style="width:300px; height: 150px;  position:relative; left: 2px;">
                <input type="radio" name="subsetAttributesExplorationRadio"  value="RepresentativeElementSubsetAttributes" checked> Subset of Attributes<br>
                <!--input type="radio" name="subsetAttributesExplorationRadio" value="ForceLayoutSubsetAttributes"> Force Layout Visualization<br-->
                <input type="radio" name="subsetAttributesExplorationRadio"  value="CorrelationMatrixSubsetAttributes"> Correlation Matrix<br>
                <!--input type="radio" name="subsetAttributesExplorationRadio" value="GeneralProjection"> General Projection  <br-->


            </div>
        </div>
        <div class="col-sm-12" style="margin:0 auto; margin:auto; text-align: center;">
            <button  id="createSubsetAttributesVisualization" name="createSubsetAttributesVisualization"  type="button"  onclick="createSubsetAttributesVisualization('1');"><b>Visualize</b></button>
        </div>
    </div>
</div>
<br>
<br>
<table style="text-align: center; margin:0 auto; margin:auto;">
    <tr>
        <td>
            <div id="SubsetAttributesVisualizationContent">

                <%@ include file="subsetAttributesVisualizations/RepresentativeElementSubsetAttributes.jsp" %>
            </div>
          

            <br>
        </td>
        &nbsp
            <td style="position: fixed;">
                <div id="attributes_subset_frame5" >
                    <%@ include file="SelectedAttributesSubset.jsp" %>
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