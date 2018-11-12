<%-- 
    Document   : HierarchicalProjection
    Created on : Mar 24, 2016, 5:43:14 PM
    Author     : aurea
--%>




<%@page import="trees.kdtree.KDTree"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="projection.ForceSchemeProjection2D"%>
<%@page import="projection.FastmapProjection"%>
<%@page import="projection.IDMAPProjection"%>
<%@page import="utils.Util"%>
<%@page import="tsne.TSneProjection"%>
<%@page import="projection.ProjClusProjection"%>
<%@page import="clustering.Clustering"%>
<%@page import="projection.ProjMeansProjection"%>
<%@page import="utils.Operations"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

    String hierarchicalLevelRangeStr = request.getParameter("hierarchicalLevelRange");
    String datasetProjection = null;
    //QuadTree quadTree = null;
    KDTree tree=null;
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    int numberMaxGroup = 0;
  int hierarchicalLevelRange =1;
    if (hierarchicalLevelRangeStr == null) {

        tree = (KDTree) session.getAttribute("tree");
        numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");

        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsData.size() / 4;
        }
        datasetProjection = tree.getD3VariableSubNodesByLevel(tree.getRoot(), 1, listTimeIntervalsData, colorScaleBackground);
        
    } else {
        hierarchicalLevelRange = Integer.valueOf(hierarchicalLevelRangeStr);
         tree = (KDTree) session.getAttribute("tree");
        numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        int currentLevel = hierarchicalLevelRange * tree.getDepth()/100;

        if(currentLevel==0)
        {
            currentLevel=1;
        }
        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsData.size() / 4;
        }
        datasetProjection = tree.getD3VariableSubNodesByLevel(tree.getRoot(), currentLevel, listTimeIntervalsData, colorScaleBackground);

    }
%>    

<br>
<table style="width: 400px; margin:0 auto; margin:auto; border-color: black; ">
    <tr>

        <td style="width:50%;  "> 
            <div id="titleProjection"><b>Hierarchical</b></div>
        </td>
        <td style="width:50%;  "> 
            <input type="range" name="hierarchicalLevelRange" id="hierarchicalLevelRange" min="1" max="101" value="<%=hierarchicalLevelRange%>" onchange="updateHierarchicalProjection();" >
        </td>
    </tr>
    <td colspan="2">

        <!--button  id="updateProjectionCluster" name="updateProjectionCluster"  type="button"  onclick="
                        updateHierarchicalProjection();"><b>Update</b></button-->

    </td>
    <tr>

    </tr>
</table>
<br>
<table style="width: 1500px;height: 580px; margin:0 auto; margin:auto; border-color: black; " border="2">

    <tr>
        <td style="width: 1500px;height:580px; text-align: center; " >
            <div id="generalProjectionContent">  
                <script type="text/javascript"> createCGVisHierarchicalProjection("generalProjectionContent", "1500", "580", "<%=datasetProjection%>", "<%=numberMaxGroup%>");</script> 
            </div>
        </td>
    </tr>
</table>

