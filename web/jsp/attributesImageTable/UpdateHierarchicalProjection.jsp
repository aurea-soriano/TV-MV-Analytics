<%-- 
    Document   : UpdateHierarchicalProjection
    Created on : Aug 9, 2016, 5:35:02 PM
    Author     : aurea
--%>


<%@page import="distance.EuclideanSimilarity"%>
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

    String hierarchicalLevelRangeStr = request.getParameter("hierarchicalLevelRange");
    int hierarchicalLevelRange = 1;

    String projection = request.getParameter("projection");
    String datasetProjection = null;
    //QuadTree quadTree = null;
    KDTree tree = null;

    AbstractMatrix abstractMatrix = (DenseMatrix) session.getAttribute("abstractMatrix");
    AbstractMatrix projectedMatrix;
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    Integer numberMaxGroup = listTimeIntervalsData.size() / 4;
    if (projection.equals("LSP")) {
        LSPProjection2D lsp = new LSPProjection2D();
        //lsp.setNumberNeighbors(3);
        lsp.setControlPointsChoice(ControlPointsType.KMEANS);
            //lsp.setFractionDelta(4.0f);
        // lsp.setNumberIterations(50);
        lsp.setNumberControlPoints(abstractMatrix.getRowCount() / 10);
        projectedMatrix = lsp.project(abstractMatrix, new EuclideanSimilarity());

    } else {

        if (projection.equals("ProjClusProjection")) {
            ProjClusProjection projectionTechnique2 = new ProjClusProjection();
            projectedMatrix = projectionTechnique2.project(abstractMatrix, new EuclideanSimilarity());
        } else {

            if (projection.equals("FastMapProjection")) {
                FastmapProjection projectionTechnique4 = new FastmapProjection();
                projectedMatrix = projectionTechnique4.project(abstractMatrix, new EuclideanSimilarity());
            } else {
                if (projection.equals("ForceSchemeProjection")) {
                    ForceSchemeProjection2D projectionTechnique5 = new ForceSchemeProjection2D();
                    projectedMatrix = projectionTechnique5.project(abstractMatrix, new EuclideanSimilarity());
                } else {
                    if (projection.equals("IDMAPProjection")) {
                        IDMAPProjection projectionTechnique6 = new IDMAPProjection();
                        projectedMatrix = projectionTechnique6.project(abstractMatrix, new EuclideanSimilarity());
                    } else {
                        projectedMatrix = null;
                    }
                }
            }

        }
    }
    float maxY = Float.MIN_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float minX = Float.MAX_VALUE;

    ArrayList<Point2D> points = new ArrayList<Point2D>();
    ArrayList<ArrayList<Integer>> labels = new ArrayList<ArrayList<Integer>>();

    if (projectedMatrix != null) {
        for (int i = 0; i < projectedMatrix.getRowCount(); i++) {
            if (maxX < projectedMatrix.getRow(i).getValue(0)) {
                maxX = projectedMatrix.getRow(i).getValue(0);
            }
            if (maxY < projectedMatrix.getRow(i).getValue(1)) {
                maxY = projectedMatrix.getRow(i).getValue(1);
            }
            if (minX > projectedMatrix.getRow(i).getValue(0)) {
                minX = projectedMatrix.getRow(i).getValue(0);
            }
            if (minY > projectedMatrix.getRow(i).getValue(1)) {
                minY = projectedMatrix.getRow(i).getValue(1);
            }
        }

        for (int i = 0; i < projectedMatrix.getRowCount(); i++) {
            int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(0), minX, maxX, 40.f, 1050.f));
            int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(1), minY, maxY, 40.f, 180.f));

            // tree.insert(new Point(valueX, valueY), i);
            int position = points.indexOf(new Point2D(valueX, valueY));
            if (position != -1) {
                labels.get(position).add(i);
            } else {
                points.add(new Point2D(valueX, valueY));
                ArrayList<Integer> subListLabels = new ArrayList<Integer>();
                subListLabels.add(i);
                labels.add(subListLabels);

            }

        }

        numberMaxGroup = 0;

        ArrayList<KDData> listData = new ArrayList<KDData>();
        for (int i = 0; i < points.size(); i++) {
            listData.add(new KDData(points.get(i), labels.get(i)));
        }

        tree = new KDTree();
        tree.buildKDTree(0, listData);

        if (tree.getRoot().getLeft() != null) {

            int maxNumber = 0;
            maxNumber = tree.getNumberSubNodesPointsByLevel(tree.getRoot().getLeft(), 1, maxNumber);
            if (maxNumber > numberMaxGroup) {
                numberMaxGroup = maxNumber;
            }
        }
        if (tree.getRoot().getRight() != null) {
            int maxNumber = 0;
            maxNumber = tree.getNumberSubNodesPointsByLevel(tree.getRoot().getRight(), 1, maxNumber);
            if (maxNumber > numberMaxGroup) {
                numberMaxGroup = maxNumber;
            }
        }
        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsData.size() / 4;
        }
        if (hierarchicalLevelRangeStr != null) {
            hierarchicalLevelRange = (Integer.valueOf(hierarchicalLevelRangeStr) * tree.getDepth() / 100) + 1;//;
        }
        datasetProjection = tree.getD3VariableSubNodesByLevel(tree.getRoot(), hierarchicalLevelRange, listTimeIntervalsData, colorScaleBackground);

         session.setAttribute("projection", projection);
        session.setAttribute("projectedMatrix", projectedMatrix);
        session.setAttribute("datasetProjection", datasetProjection);
        session.setAttribute("maxY", maxY);
        session.setAttribute("minY", minY);
        session.setAttribute("maxX", maxX);
        session.setAttribute("minX", minX);
        session.setAttribute("tree", tree);
        session.setAttribute("currentNode", tree.getRoot());
        session.setAttribute("currentLevel", 1);
        session.setAttribute("numberMaxGroup", numberMaxGroup);
    }
%>    


<script type="text/javascript"> createCGVisGeneralProjectionMatrices("generalProjectionContent", "1110", "240", "<%=datasetProjection%>", "<%=numberMaxGroup%>");</script> 

