<%-- 
    Document   : InstanceHierarchicalProjectionMap
    Created on : Jul 4, 2016, 3:25:33 PM
    Author     : aurea
--%>
<%@page import="distance.PearsonCorrelation"%>
<%@page import="distance.Euclidean"%>
<%@page import="categorization.Condition"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.EuclideanSimilarity"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="categorization.CategorizationObject"%>
<%@page import="trees.kdtree.KDTree"%>
<%@page import="trees.kdtree.KDData"%>
<%@page import="trees.kdtree.Point2D"%>
<%@page import="projection.IDMAPProjection"%>
<%@page import="java.util.Collections"%>
<%@page import="color.HeatedObject"%>
<%@page import="clustering.SilhouetteCoefficient"%>
<%@page import="normalization.Standardization"%>
<%@page import="normalization.NormalizeColumns"%>
<%@page import="normalization.Normalization"%>
<%@page import="projection.FastmapProjection"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="utils.Operations"%>
<%@page import="projection.ForceSchemeProjection2D"%>
<%@page import="projection.ProjClusProjection"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="projection.LSPProjection2D"%>
<%@page import="categorization.Tiwari2011Sigma"%>
<%@page import="categorization.Hegarty2001Sigma"%>
<%@page import="categorization.ITUR2013S4"%>
<%@page import="categorization.Tiwari2011S4"%>
<%@page import="categorization.Hegarty2001S4"%>
<%@page import="categorization.Categorization"%>
<%@page import="matrix.pointsmatrix.AbstractVector"%>
<%@page import="matrix.pointsmatrix.DenseVector"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="utils.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%

    ArrayList<TimeInterval> listTimeIntervalAttributes3 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    Color[] colorScaleBackground = new HeatedObject().getColorScale();

    ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
    Integer idAttributeTarget = Integer.valueOf(request.getParameter("idAttributeTarget"));
    String categorizationId = request.getParameter("categorization");

    String colorStrategy = request.getParameter("colorStrategy");
    String nameProjectionTechnique = request.getParameter("nameProjectionTechnique");

    Integer numberMaxGroup = 0;
    Integer hierarchicalLevelRange = 1;

    ArrayList<Float> listKlasses = new ArrayList<Float>();
    AbstractMatrix instanceMatrix = new DenseMatrix();

    ArrayList<Float> listLabels = new ArrayList<Float>();
    ArrayList<String> listDates = new ArrayList<String>();

    //categorization 
    ArrayList<CategorizationObject> listCategorization1 = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
    CategorizationObject categorization = listCategorization1.get(Integer.valueOf(categorizationId));

    int numberCols = 0;
    int numberRows = 0;
    int vectorSize = 0;
    if (!selectedAttributesSubset.isEmpty()) {

        numberRows = listTimeIntervalAttributes3.get(selectedAttributesSubset.get(0)).getMatrix().getRows();
        numberCols = listTimeIntervalAttributes3.get(selectedAttributesSubset.get(0)).getMatrix().getCols();
        vectorSize = selectedAttributesSubset.size();

    }
    for (int countRows = 0; countRows < numberRows; countRows++) {
        for (int countCols = 0; countCols < numberCols; countCols++) {
            float[] vectorValues = new float[vectorSize];
            boolean nanBool = false;

            for (int countSelectedAttributes = 0; countSelectedAttributes < selectedAttributesSubset.size(); countSelectedAttributes++) {
                Double value = listTimeIntervalAttributes3.get(selectedAttributesSubset.get(countSelectedAttributes)).getMatrix().getOriginalValue(countRows, countCols);
                if (!value.isNaN()) {
                    double value2 = value;
                    vectorValues[countSelectedAttributes] = (float) value2;
                } else {
                    nanBool = true;
                    vectorValues[countSelectedAttributes] = Float.MIN_VALUE;
                }

            }

            Double originalCategorizationValue = listTimeIntervalAttributes3.get(idAttributeTarget).getMatrix().getOriginalValue(countRows, countCols);
            double originalCategorizationValue2 = originalCategorizationValue;
            if (originalCategorizationValue.isNaN()) {
                nanBool = true;
            }
            float categorizationValue = (float) originalCategorizationValue2;

            if (nanBool == false) {
                AbstractVector vector = new DenseVector(vectorValues);
                if (colorStrategy.equals("categorized")) {
                    float valueTypeCategorization = categorization.calculateClass(categorizationValue);
                    vector.setKlass((float) valueTypeCategorization);
                    listKlasses.add((float) valueTypeCategorization);

                } else {
                    float klass = Math.abs(categorizationValue * 100) / 100;
                    vector.setKlass(klass);
                    listKlasses.add(klass);

                }
                instanceMatrix.addRow(vector);
                listLabels.add(categorizationValue);
                listDates.add(listTimeIntervalAttributes3.get(idAttributeTarget).getListLabelsY().get(countRows) + " " + listTimeIntervalAttributes3.get(idAttributeTarget).getListLabelsX().get(countCols));
            }

        }
    }

    //normalization
    Normalization normalization = new Standardization();
    AbstractMatrix normalizedMatrix = normalization.execute(instanceMatrix);

    //projection
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

    AbstractMatrix projectedMatrix = null;
    if (nameProjectionTechnique.equals("LSP")) {
        LSPProjection2D lsp = new LSPProjection2D();
        lsp.setControlPointsChoice(ControlPointsType.KMEANS);
        //lsp.setNumberNeighbors(3);
        lsp.setNumberControlPoints(normalizedMatrix.getRowCount() / 10);
        projectedMatrix = lsp.project(normalizedMatrix, dissimilarity);

    } else {

        if (nameProjectionTechnique.equals("ProjClusProjection")) {
            ProjClusProjection projectionTechnique2 = new ProjClusProjection();
            projectedMatrix = projectionTechnique2.project(normalizedMatrix, dissimilarity);
        } else {

            if (nameProjectionTechnique.equals("FastMapProjection")) {
                FastmapProjection projectionTechnique4 = new FastmapProjection();
                projectedMatrix = projectionTechnique4.project(normalizedMatrix, dissimilarity);
            } else {
                if (nameProjectionTechnique.equals("ForceSchemeProjection")) {
                    ForceSchemeProjection2D projectionTechnique5 = new ForceSchemeProjection2D();
                    projectedMatrix = projectionTechnique5.project(normalizedMatrix, dissimilarity);
                } else {
                    if (nameProjectionTechnique.equals("IDMAPProjection")) {
                        IDMAPProjection projectionTechnique6 = new IDMAPProjection();
                        projectedMatrix = projectionTechnique6.project(normalizedMatrix, dissimilarity);
                    } else {
                        projectedMatrix = null;
                    }
                }
            }

        }
    }

    //silhouette coefficient
    SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
    float[] silhouetteCoefficients = {0.f};
    try {
        silhouetteCoefficients = silhouetteCoefficient.execute(projectedMatrix, new EuclideanSimilarity());
    } catch (Exception e) {

    }
    String color4 = "f0f8ff";
    String color3 = "087830";
    String color2 = "ffbf00";
    String color1 = "a40000";
    float averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
    averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;

    float maxY = Float.MIN_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float minX = Float.MAX_VALUE;

    Color[] colorKlasses = (new HeatedObject()).getColorScale();
    float maxValueKlass = Collections.max(listKlasses);
    float minValueKlass = Collections.min(listKlasses);
    ArrayList<Point2D> pointsKdTree = new ArrayList<Point2D>();
    ArrayList<ArrayList<Integer>> labelsKdTree = new ArrayList<ArrayList<Integer>>();
    String datasetProjection = "";
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
            int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(0), minX, maxX, 20.f, 1000.f));
            int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(1), minY, maxY, 20.f, 740.f));

            int position = pointsKdTree.indexOf(new Point2D(valueX, valueY));
            if (position != -1) {
                labelsKdTree.get(position).add(i);
            } else {
                pointsKdTree.add(new Point2D(valueX, valueY));
                ArrayList<Integer> subListLabels = new ArrayList<Integer>();
                subListLabels.add(i);
                labelsKdTree.add(subListLabels);

            }

        }
        numberMaxGroup = 0;

        ArrayList<KDData> listData = new ArrayList<KDData>();
        for (int i = 0; i < pointsKdTree.size(); i++) {
            listData.add(new KDData(pointsKdTree.get(i), labelsKdTree.get(i)));
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
        if (numberMaxGroup == 0) {
            numberMaxGroup = projectedMatrix.getRowCount();
        }

        hierarchicalLevelRange = 1;
        datasetProjection = tree.getD3InstancesSubNodesByLevel(tree.getRoot(), 1, projectedMatrix, colorStrategy,
                colorScaleBackground, listKlasses, listDates, categorization);

        session.setAttribute("idAttributeTarget", idAttributeTarget);
        session.setAttribute("categorizationId", categorizationId);

        session.setAttribute("projectedMatrixHP", projectedMatrix);
        session.setAttribute("treeHP", tree);
        session.setAttribute("listKlassesHP", listKlasses);
        session.setAttribute("listLabelsHP", listLabels);
        session.setAttribute("listDatesHP", listDates);
        session.setAttribute("colorStrategyHP", colorStrategy);
        session.setAttribute("numberMaxGroupHP", numberMaxGroup);
        session.setAttribute("categorizationHP", categorization);

    }

%>
<html>
    <head>
        <meta content='text/html; charset=utf-8' http-equiv='Content-Type'>

        <title>Visual Analytics </title>
        <link rel="shortcut icon" href="favicon.ico" />
        <!--link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,700' rel='stylesheet' type='text/css'-->
        <!--link href='css/opensans_googleapis.css' rel='stylesheet' type='text/css'-->
        <!--link href='https://fonts.googleapis.com/css?family=PT+Serif:400,700,400italic' rel='stylesheet' type='text/css'-->
        <!--link href='css/ptitalic_googleapis.css' rel='stylesheet' type='text/css'-->
        <link href='../../css/font-awesome.css' rel='stylesheet' type='text/css'>
        <link href='../../css/bootstrap.min.css' rel='stylesheet' type='text/css'>
        <link href='../../css/jquery-ui.css' rel='stylesheet' type='text/css'>
        <link href='../../css/normalize.min.css' rel='stylesheet' type='text/css'>
        <link href='../../css/scaleColor.css' rel=stylesheet type="text/css" >
        <link href='../../css/menu.css' rel=stylesheet type="text/css" >
        <link href="../../css/multiple-select.css" rel="stylesheet" type="text/css">


        <script src="../../js/ajax.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/main.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.form.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.v3.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.v3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/clustersGraphVisualization.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/multiple-select.js" type="text/javascript" charset="utf-8"></script>
    </head>


    <body>
        <table style="margin:0 auto; margin:auto; margin-left: 2.7%; "><tr><td>
                    <table  style="border-color: black; width: 1100px; height: 820px;"  border="1">

                        <tr><td colspan="2" style="text-align: center;margin:0 auto; margin:auto;">
                                <input  style="width:200px;" type="range" name="hierarchicalInstanceLevelRange" 
                                        id="hierarchicalInstanceLevelRange" min="1" max="101" step="2" value="<%=hierarchicalLevelRange%>" 
                                        onchange="updateHierarchicalInstanceProjectionButton();" >

                            </td></tr>
                        <tr>
                            <td> <b># instances: </b> <%=projectedMatrix.getRowCount()%> <b>- # variables: </b>  <%=selectedAttributesSubset.size()%>
                            </td>
                            <td>   <b>Silhouette Coefficient: </b> <%=averageSilhouetteCoefficient%></td>
                        </tr> 
                        <tr>

                            <td  colspan="2"> 
                                <%
                                    int numberClasses = Integer.valueOf(categorization.getNumberClasses());
                                    int numberConditions = Integer.valueOf(categorization.getNumberConditions());
                                    if (colorStrategy.equals("categorized")) {

                                %>
                                <table border="1" style="width: 100%">
                                    <tr>
                                        <% ArrayList<Condition> listConditions = categorization.getListConditions();
                                            for (int aux = 0; aux < listConditions.size(); aux++) {
                                                String conditionStr = listConditions.get(aux).getDescription(listTimeIntervalAttributes3.get(idAttributeTarget).getNameAttribute());
                                                conditionStr = Util.replaceStringOperators(conditionStr);
                                                String cellColor = "ffffff";
                                                if (Double.valueOf(listConditions.get(aux).getClassValue()) == 4.0) {
                                                    cellColor = color4;
                                                } else {
                                                    if (Double.valueOf(listConditions.get(aux).getClassValue()) == 3.0) {
                                                        cellColor = color3;
                                                    } else {
                                                        if (Double.valueOf(listConditions.get(aux).getClassValue()) == 2.0) {
                                                            cellColor = color2;
                                                        } else {
                                                            if (Double.valueOf(listConditions.get(aux).getClassValue()) == 1.0) {
                                                                cellColor = color1;
                                                            }
                                                        }
                                                    }
                                                }
                                                Color bColor = Color.decode("#" + cellColor);
                                                String textColor = Util.getColorByLuminance(bColor);
                                        %>
                                        <td style="text-align: center; background-color:  <%=cellColor%>; color: <%=textColor%>">
                                            <%="(" + listConditions.get(aux).getClassValue() + ")" + conditionStr%>
                                        </td>
                                        <%}%>
                                    </tr>
                                </table> 
                                <%} else {%>
                                <table style="width: 100%; margin:0 auto; margin:auto;text-align: center;">
                                    <tr>
                                        <td><%=minValueKlass%> </td>
                                        <% for (int i = 255; i > 0; i--) {

                                                Color cellColor = colorKlasses[i];
                                        %>
                                        <td style="text-align: center; background-color: rgb(<%out.print(cellColor.getRed());%>,<%out.print(cellColor.getGreen());%>,<%out.print(cellColor.getBlue());%>)";
                                            width="4px" >
                                        </td>
                                        <%}%>
                                        <td>
                                            <%=maxValueKlass%></td>
                                    </tr>
                                </table>
                                <%}%>
                            </td>
                        </tr> 

                        <tr>
                            <td colspan="2" style=" width: 1110px; height: 780px;text-align: center;">
               <div id="instanceProjectionMapContent"     >  
                                    <script type="text/javascript"> createHierarchicalInstanceProjection("instanceProjectionMapContent", "1010", "760",
                                                "<%=datasetProjection%>", "<%=numberMaxGroup%>");</script> 
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table style="width: 300px;">
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <button  id="resultsSubsetTimeMatricesButton" name="resultsSubsetTimeMatricesButton"  type="button"  
                                         onclick="resultsSubsetTimeMatrices('true');
                                         "><b>Calculate Results</b></button>
                            </td></tr>
                        <tr>
                            <td>
                                <div id="classiferResultsContent"></div></td></tr>

                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>