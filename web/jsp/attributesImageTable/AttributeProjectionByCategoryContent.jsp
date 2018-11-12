<%-- 
    Document   : AttributeProjectionByCategoryContent
    Created on : Jun 12, 2017, 10:32:02 PM
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
    
    String datasetProjectionCategory = null;
    //QuadTree quadTree = null;
    KDTree treeCategory = null;
    ArrayList<TimeInterval> listTimeIntervalsDataCategory = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsDataCategory");
    int numberMaxGroup = 0;
    int hierarchicalLevelRange = 1;
    if (hierarchicalLevelRangeStr == null) {

        treeCategory = (KDTree) session.getAttribute("treeCategory");
        numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");

        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsDataCategory.size() / 4;
        }
        datasetProjectionCategory = treeCategory.getD3VariableSubNodesByLevel(treeCategory.getRoot(), 1, listTimeIntervalsDataCategory, colorScaleBackground);

    } else {
        hierarchicalLevelRange = Integer.valueOf(hierarchicalLevelRangeStr);
        treeCategory = (KDTree) session.getAttribute("treeCategory");
        numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        int currentLevel = (hierarchicalLevelRange * treeCategory.getDepth() / 100)+1;

        if (currentLevel == 0) {
            currentLevel = 1;
        }
        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsDataCategory.size() / 4;
        }
        datasetProjectionCategory = treeCategory.getD3VariableSubNodesByLevel(treeCategory.getRoot(), currentLevel, listTimeIntervalsDataCategory, colorScaleBackground);

    }
%>    


<script type="text/javascript"> createHierarchicalProjectionMatricesByCategory("generalProjectionContentCategory", "1190", "240", "<%=datasetProjectionCategory%>", "<%=numberMaxGroup%>");</script> 

