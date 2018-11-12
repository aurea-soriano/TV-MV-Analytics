<%-- 
    Document   : index
    Created on : Feb 15, 2016, 4:19:07 PM
    Author     : aurea
--%>


<%@page import="distance.PearsonCorrelation"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.Euclidean"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="projection.LSPProjection2D"%>
<%@page import="trees.kdtree.KDData"%>
<%@page import="trees.kdtree.Point2D"%>
<%@page import="trees.kdtree.KDTree"%>
<%@page import="java.awt.Point"%>
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

    String nameProjectionTechnique = request.getParameter("nameProjectionTechnique");
    if (nameProjectionTechnique == null) {
        nameProjectionTechnique = "IDMAPProjection";
    }
    String datasetProjection = null;

    Clustering clusteringMethod = (Clustering) session.getAttribute("clusteringMethod");
    AbstractMatrix abstractMatrix = (DenseMatrix) session.getAttribute("abstractMatrix");
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    AbstractMatrix projectedMatrix = null;
     AbstractDissimilarity dissimilarity = new Euclidean();
        String selectedSimilarity = (String) session.getAttribute("selectedSimilarity");
        if (selectedSimilarity == null) {
            selectedSimilarity = "Euclidean";
        }

        if (selectedSimilarity.equals("Euclidean")) {
            dissimilarity = new Euclidean();
        } else {
            if (selectedSimilarity.equals("Manhattan")) {
                dissimilarity = new ManhattanSimilarity();
            } else {
                if (selectedSimilarity.equals("Pearson")) {
                    dissimilarity = new PearsonCorrelation();

                } else {
                    dissimilarity = new Euclidean();
                }
            }
        }
        
    if (nameProjectionTechnique.equals("LSP")) {
        LSPProjection2D lsp = new LSPProjection2D();
       // lsp.setNumberNeighbors(3);
        lsp.setControlPointsChoice(ControlPointsType.RANDOM);
    //lsp.setFractionDelta(4.0f);
        // lsp.setNumberIterations(50);
        lsp.setNumberControlPoints(10);
        projectedMatrix = lsp.project(abstractMatrix, dissimilarity);

    } else {
        if (nameProjectionTechnique.equals("ProjMeansProjection")) {
            ProjMeansProjection projectionTechnique1 = new ProjMeansProjection();
            projectionTechnique1.setCentroids(clusteringMethod.getCentroids());
            projectionTechnique1.setClusters(resultClustering);
            projectedMatrix = projectionTechnique1.project(abstractMatrix, dissimilarity);
        } else {
            if (nameProjectionTechnique.equals("ProjClusProjection")) {
                ProjClusProjection projectionTechnique2 = new ProjClusProjection();
                projectedMatrix = projectionTechnique2.project(abstractMatrix, dissimilarity);
            } else {
                if (nameProjectionTechnique.equals("TSneProjection")) {
                    TSneProjection projectionTechnique3 = new TSneProjection();
                    double perplexity = 150.0;//Util.perplexity(resultClustering, abstractMatrix.getRowCount());
                    projectionTechnique3.setPerplexity(perplexity);
                    projectedMatrix = projectionTechnique3.project(abstractMatrix, dissimilarity);
                } else {
                    if (nameProjectionTechnique.equals("FastMapProjection")) {
                        FastmapProjection projectionTechnique4 = new FastmapProjection();
                        projectedMatrix = projectionTechnique4.project(abstractMatrix, dissimilarity);
                    } else {
                        if (nameProjectionTechnique.equals("ForceSchemeProjection")) {
                            ForceSchemeProjection2D projectionTechnique5 = new ForceSchemeProjection2D();
                            projectedMatrix = projectionTechnique5.project(abstractMatrix, dissimilarity);
                        } else {
                            if (nameProjectionTechnique.equals("IDMAPProjection")) {
                                IDMAPProjection projectionTechnique6 = new IDMAPProjection();
                                projectedMatrix = projectionTechnique6.project(abstractMatrix, dissimilarity);
                            } else {
                                projectedMatrix = null;
                            }
                        }
                    }
                }
            }
        }
    }
    float maxY = Float.MIN_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float minX = Float.MAX_VALUE;
    /* ArrayList<Point> bounds = new ArrayList<Point>();
     bounds.add(new Point(0, 0));
     bounds.add(new Point(1401, 561));*/
    ArrayList<Point2D> points = new ArrayList<Point2D>();
    ArrayList<ArrayList<Integer>> labels = new ArrayList<ArrayList<Integer>>();

    datasetProjection = "[";
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
            int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(0), minX, maxX, 50.f, 1400.f));
            int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(1), minY, maxY, 20.f, 560.f));

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

            int indexColorBackground = listTimeIntervalsData.get(i).getIndexColorCluster();
            Color colorBackground;
            if (indexColorBackground == -1) {
                colorBackground = Color.GRAY.brighter();
            } else {
                colorBackground = colorScaleBackground[indexColorBackground];
            }
            datasetProjection += "{\'x\':" + valueX + ", \'y\':" + valueY + ",\'color\':\'" + Integer.toHexString(colorBackground.getRGB()).substring(2) + "\', \'name\':\'" + "#" + (listTimeIntervalsData.get(i).getCluster()) + "-" + listTimeIntervalsData.get(i).getNameAttribute() + "-" + listTimeIntervalsData.get(i).getInitHour() + ":00-" + listTimeIntervalsData.get(i).getEndHour() + ":00" + "\'},";

        }
        if (datasetProjection.endsWith(",")) {
            datasetProjection = datasetProjection.substring(0, datasetProjection.length() - 1);
        }
    }
    System.out.println(datasetProjection);
    int numberMaxGroup = 0;

    ArrayList<KDData> listData = new ArrayList<KDData>();
    for (int i = 0; i < points.size(); i++) {
        listData.add(new KDData(points.get(i), labels.get(i)));
    }

    KDTree tree = new KDTree();
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
    /*if (qt.getRoot().getBottomLeft() != null) {

     int maxNumber = 0;
     maxNumber = qt.getNumberSubNodesPointsByLevel(qt.getRoot().getBottomLeft(), 1, maxNumber);
     if (maxNumber > numberMaxGroup) {
     numberMaxGroup = maxNumber;
     }
     }
     if (qt.getRoot().getBottomRight() != null) {
     int maxNumber = 0;
     maxNumber = qt.getNumberSubNodesPointsByLevel(qt.getRoot().getBottomRight(), 1, maxNumber);
     if (maxNumber > numberMaxGroup) {
     numberMaxGroup = maxNumber;
     }
     }
     if (qt.getRoot().getTopLeft() != null) {
     int maxNumber = 0;
     maxNumber = qt.getNumberSubNodesPointsByLevel(qt.getRoot().getTopLeft(), 1, maxNumber);
     if (maxNumber > numberMaxGroup) {
     numberMaxGroup = maxNumber;
     }
     }
     if (qt.getRoot().getTopRight() != null) {
     int maxNumber = 0;
     maxNumber = qt.getNumberSubNodesPointsByLevel(qt.getRoot().getTopRight(), 1, maxNumber);
     if (maxNumber > numberMaxGroup) {
     numberMaxGroup = maxNumber;
     }
     }*/
    datasetProjection += "]";
    session.setAttribute("projectedMatrix", projectedMatrix);
    session.setAttribute("datasetProjection", datasetProjection);
    session.setAttribute("nameProjectionTechnique", nameProjectionTechnique);
    session.setAttribute("maxY", maxY);
    session.setAttribute("minY", minY);
    session.setAttribute("maxX", maxX);
    session.setAttribute("minX", minX);
    session.setAttribute("tree", tree);
    session.setAttribute("currentNode", tree.getRoot());
    session.setAttribute("currentLevel", 1);
    session.setAttribute("numberMaxGroup", numberMaxGroup);
%>    

<br>
<table style="width: 400px; margin:0 auto; margin:auto; border-color: black; ">
    <tr>

        <td style="width:50%;  "> 
            <div id="titleProjection"><b>Projection:</b></div>
        </td>
        <td style="width:50%;  "> 
            <select name="selectProjectionCluster" id="selectProjectionCluster"    style="width: 135px" >

                <option value="LSP"<%                                                if (nameProjectionTechnique != null && nameProjectionTechnique.equals("LSP")) {%>
                        selected
                        <%}%>
                        >LSP - Paulovich</option>
                <option value="ProjClusProjection"<%
                    if (nameProjectionTechnique != null && nameProjectionTechnique.equals("ProjClusProjection")) {%>
                        selected
                        <%}%>
                        >ProjClusProjection-Paulovich</option>
                <option value="TSneProjection" <%
                    if (nameProjectionTechnique != null && nameProjectionTechnique.equals("TSneProjection")) {%>
                        selected
                        <%}
                        %>>TSne -Maaten</option>
                <option value="FastMapProjection" <%
                    if (nameProjectionTechnique != null && nameProjectionTechnique.equals("FastMapProjection")) {%>
                        selected
                        <%}
                        %>>FastMap-Faloutsos</option>
                <option value="ForceSchemeProjection" <%
                    if (nameProjectionTechnique != null && nameProjectionTechnique.equals("ForceSchemeProjection")) {%>
                        selected
                        <%}
                        %>>Force Scheme-Tejada</option>
                <option value="IDMAPProjection" <%
                    if (nameProjectionTechnique != null && nameProjectionTechnique.equals("IDMAPProjection")) {%>
                        selected
                        <%}
                        %>>IDMAP -Minghim</option>

            </select>

        </td>
    </tr>
    <td colspan="2">

        <button  id="updateProjectionCluster" name="updateProjectionCluster"  type="button"  onclick="updateProjectionCluster();"><b>Update</b></button>

    </td>
    <tr>

    </tr>
</table>
<br>
<table style="width: 1500px;height: 580px; margin:0 auto; margin:auto; border-color: black; " border="2">

    <tr>
        <td style="width: 1500px;height:580px; text-align: center; " >
            <div id="generalProjectionContent">  
                <script type="text/javascript"> createCGVisGeneralProjection("generalProjectionContent", "1500", "580", "<%=datasetProjection%>");</script> 
            </div>
        </td>
    </tr>
</table>

