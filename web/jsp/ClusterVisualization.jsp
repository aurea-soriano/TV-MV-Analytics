<%-- 
    Document   : ClustersGraph
    Created on : Feb 11, 2016, 8:00:51 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    if ((ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData") != null) {
       
%>
<br>
<div class="container-fluid" style="width:300px; height: 175px;   margin:0 auto; margin:auto;">
    <div class="row">

        <div class="col-sm-2">
            <div class="well" style="width:300px; height: 175px;  position:relative; left: 2px;">
                <input type="radio" name="clusterExplorationRadio"  value="RepresentativeElementByCluster" checked> Representative Element By Cluster<br>
                <!--input type="radio" name="clusterExplorationRadio" value="ForceLayoutVisualizationByCluster"> Force Layout Visualization By Cluster<br-->
                <input type="radio" name="clusterExplorationRadio"  value="CorrelationMatrix"> Correlation Matrix (Pearson)<br>
                <input type="radio" name="clusterExplorationRadio" value="GeneralProjection"> General Projection  <br>
                <input type="radio" name="clusterExplorationRadio" value="HierarchicalProjection"> Hierarchical Projection  <br>

            </div>
        </div>
        <div class="col-sm-12" style="margin:0 auto; margin:auto; text-align: center;">
            <button  id="createClusterVisualization" name="createClusterVisualization"  type="button"  onclick="createClusterVisualization('1');"><b>Visualize</b></button>
        </div>
    </div>
</div>
<br>
<br>
<table style="text-align: center; margin:0 auto; margin:auto;">
    <tr>
        <td>
            <div id="ClusterVisualizationContent">

                <%@ include file="clusterVisualizations/RepresentativeElementByCluster.jsp" %>
            </div>


            <br>
        </td>
        &nbsp
        <td style="position: fixed;">
            <div id="attributes_subset_frame2" >
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