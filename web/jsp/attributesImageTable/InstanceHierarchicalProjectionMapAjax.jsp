<%-- 
    Document   : InstanceHierarchicalProjectionMapAjax
    Created on : Aug 10, 2016, 7:06:30 PM
    Author     : aurea
--%>


<%@page import="categorization.CategorizationObject"%>
<%@page import="color.HeatedObject"%>
<%@page import="categorization.Categorization"%>
<%@page import="trees.kdtree.KDData"%>
<%@page import="trees.kdtree.Point2D"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="projection.LSPProjection2D"%>
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

    String hierarchicalInstanceLevelRangeStr = request.getParameter("hierarchicalInstanceLevelRange");
    AbstractMatrix projectedMatrixHP = (AbstractMatrix) session.getAttribute("projectedMatrixHP");
    ArrayList<Float> listKlassesHP = (ArrayList<Float>) session.getAttribute("listKlassesHP");
    ArrayList<Float> listLabelsHP = (ArrayList<Float>) session.getAttribute("listLabelsHP");
    ArrayList<String> listDatesHP = (ArrayList<String>) session.getAttribute("listDatesHP");
    String colorStrategyHP = (String) session.getAttribute("colorStrategyHP");

    Color[] colorScaleBackground = new HeatedObject().getColorScale();
    KDTree treeHP = (KDTree) session.getAttribute("treeHP");
    int numberMaxGroupHP = (Integer) session.getAttribute("numberMaxGroupHP");
    CategorizationObject categorizationHP = (CategorizationObject) session.getAttribute("categorizationHP");
    String datasetProjection = null;
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");

    if (hierarchicalInstanceLevelRangeStr == null) {

        if (numberMaxGroupHP == 0) {
            numberMaxGroupHP = projectedMatrixHP.getRowCount();
        }
        datasetProjection = treeHP.getD3InstancesSubNodesByLevel(treeHP.getRoot(), 1, projectedMatrixHP, colorStrategyHP,
                colorScaleBackground, listKlassesHP,listDatesHP, categorizationHP);

    } else {
        int hierarchicalInstanceLevelRange = Integer.valueOf(hierarchicalInstanceLevelRangeStr);
        int currentLevel = hierarchicalInstanceLevelRange * treeHP.getDepth() / 100;

        if (currentLevel == 0) {
            currentLevel = 1;
        }
        if (numberMaxGroupHP == 0) {
            numberMaxGroupHP = projectedMatrixHP.getRowCount();
        }
        datasetProjection = treeHP.getD3InstancesSubNodesByLevel(treeHP.getRoot(), hierarchicalInstanceLevelRange, projectedMatrixHP, colorStrategyHP,
                colorScaleBackground, listKlassesHP, listDatesHP,categorizationHP);

    }
%>    

<div id="instanceProjectionMapContentAjax">
    <script type="text/javascript"> createHierarchicalInstanceProjection("instanceProjectionMapContentAjax", "1010", "760",
                "<%=datasetProjection%>", "<%=numberMaxGroupHP%>");</script> 

</div>