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
    KDTree tree = null;
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    int numberMaxGroup = 0;
    int hierarchicalLevelRange = 1;
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
        int currentLevel = (hierarchicalLevelRange * tree.getDepth() / 100)+1;

        if (currentLevel == 0) {
            currentLevel = 1;
        }
        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsData.size() / 4;
        }
        datasetProjection = tree.getD3VariableSubNodesByLevel(tree.getRoot(), currentLevel, listTimeIntervalsData, colorScaleBackground);

    }
%>    


<script type="text/javascript"> createCGVisGeneralProjectionMatrices("generalProjectionContent", "1190", "240", "<%=datasetProjection%>", "<%=numberMaxGroup%>");</script> 

