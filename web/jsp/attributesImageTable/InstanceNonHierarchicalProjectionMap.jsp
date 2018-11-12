<%-- 
    Document   : InstanceProjectionMap
    Created on : Jul 4, 2016, 3:25:33 PM
    Author     : aurea
--%>
<%@page import="distance.Euclidean"%>
<%@page import="distance.PearsonCorrelation"%>
<%@page import="categorization.Condition"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.EuclideanSimilarity"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="categorization.CategorizationObject"%>
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
    ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

    Integer idAttributeTarget = Integer.valueOf(request.getParameter("idAttributeTarget"));
    String categorizationId = request.getParameter("categorization");

    String colorStrategy = request.getParameter("colorStrategy");
    String nameProjectionTechnique = request.getParameter("nameProjectionTechnique");

    double stepSlider = 0.0;

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

    //step slider
    if (colorStrategy.equals(
            "categorized")) {
        stepSlider = 0.5;
    } else {
        stepSlider = 0.1;
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
    normalizedMatrix.save("/home/aurea/observations.data");

    //silhouette coefficient
    SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
    float[] silhouetteCoefficients = {0.f};
    try {
        silhouetteCoefficients = silhouetteCoefficient.execute(projectedMatrix, new EuclideanSimilarity());
    } catch (Exception e) {

    }
    float averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
    averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;

    float maxY = Float.MIN_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float minX = Float.MAX_VALUE;

    String color4 = "f0f8ff";
    String color3 = "087830";
    String color2 = "ffbf00";
    String color1 = "a40000";

    Color[] colorKlasses = (new HeatedObject()).getColorScale();

    float maxValueKlass = Collections.max(listKlasses);
    float minValueKlass = Collections.min(listKlasses);
    String datasetProjection = "[";
    if (projectedMatrix
            != null) {
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

            String colorBackground = "";
            if (colorStrategy.equals("categorized")) {
                if (projectedMatrix.getRow(i).getKlass() == 4.0) {
                    colorBackground = color4;
                } else {
                    if (projectedMatrix.getRow(i).getKlass() == 3.0) {
                        colorBackground = color3;
                    } else {
                        if (projectedMatrix.getRow(i).getKlass() == 2.0) {
                            colorBackground = color2;
                        } else {
                            if (projectedMatrix.getRow(i).getKlass() == 1.0) {
                                colorBackground = color1;
                            } else {
                                colorBackground = "FFFFFF";
                            }
                        }
                    }
                }
            } else {
                int indexColor = (int) Math.abs(Operations.minmax(listKlasses.get(i), minValueKlass, maxValueKlass, 0.f, 255.f));
                indexColor = 255 - indexColor;
                colorBackground = Integer.toHexString(colorKlasses[indexColor].getRGB()).substring(2);
            }

            datasetProjection += "{\'x\':" + valueX + ", \'y\':" + valueY + ", \'color\': \'" + colorBackground
                    + "\', \'name\': \'" + listLabels.get(i) + "\', \'date\': \'" + listDates.get(i) + "\'},";

        }
        if (datasetProjection.endsWith(",")) {
            datasetProjection = datasetProjection.substring(0, datasetProjection.length() - 1);
        }
    }
    datasetProjection += "]";

    session.setAttribute("idAttributeTarget", idAttributeTarget);
    session.setAttribute("categorizationId", categorizationId);

    session.setAttribute("projectedMatrixNHP", projectedMatrix);
    session.setAttribute("listKlassesNHP", listKlasses);
    session.setAttribute("listLabelsNHP", listLabels);
    session.setAttribute("listDatesNHP", listDates);
    session.setAttribute("colorStrategyNHP", colorStrategy);
    session.setAttribute("maxXNHP", maxX);
    session.setAttribute("minXNHP", minX);
    session.setAttribute("maxYNHP", maxY);
    session.setAttribute("minYNHP", minY);

    float minValueSlider = ((float) Math.floor(minValueKlass * 100)) / 100.f;
    float maxValueSlider = ((float) Math.ceil(maxValueKlass * 100)) / 100.f;
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
                        <tr><td colspan="2" style="text-align: center;">
                                <script>
                                    $(function () {
                                        $("#sliderFilterProjection").slider({
                                            range: true,
                                            min:<%=minValueSlider%>,
                                            max:<%=maxValueSlider%>,
                                            step:<%=stepSlider%>,
                                            values: [<%=minValueSlider%>, <%=maxValueSlider%>],
                                            slide: function (event, ui) {
                                                $("#minValueInput").val(ui.values[ 0 ]);
                                                $("#maxValueInput").val(ui.values[ 1 ]);
                                            }
                                        });
                                        $("#minValueInput").val("" + $("#sliderFilterProjection").slider("values", 0) + "");
                                        $("#maxValueInput").val("" + $("#sliderFilterProjection").slider("values", 1 + ""));
                                    });</script>
                                <table style="margin:0 auto; margin:auto;">
                                    <tr>
                                        <td style="text-align: right;">
                                            <input type="text" id="minValueInput" readonly  style="border:0; font-weight:bold;text-align: right;"></td>
                                        <td style="width: 10px;"></td><td> &nbsp<div id="sliderFilterProjection" style="width: 500px"></div>&nbsp</td><td style="width: 10px;"></td>
                                        <td style="text-align: left;"> <input type="text" id="maxValueInput" readonly  style="border:0; font-weight:bold;"></td>
                                        <td>  <button  id="filterNHPButton" name="filterNHPButton"  type="button"  onclick="
                                                filterNHPInstanceProjectionButton();"><b>Filter</b></button></td>
                                    </tr>
                                </table>
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
                            <td style=" width: 1110px; height: 780px;text-align: center;" colspan="2">
               <div id="instanceProjectionMapContent"     >  
                                    <script type="text/javascript"> createInstanceProjection("instanceProjectionMapContent", "1010", "760", "<%=datasetProjection%>");</script> 
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