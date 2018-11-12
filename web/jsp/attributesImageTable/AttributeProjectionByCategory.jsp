<%-- 
    Document   : AttributeProjectionByCategory
    Created on : Jun 12, 2017, 5:27:31 PM
    Author     : aurea
--%>

<%@page import="matrix.pointsmatrix.AbstractVector"%>
<%@page import="matrix.pointsmatrix.DenseVector"%>
<%@page import="color.AureaComplete"%>
<%@page import="utils.ColorScale"%>
<%@page import="java.awt.Color"%>
<%@page import="trees.kdtree.KDTree"%>
<%@page import="trees.kdtree.KDData"%>
<%@page import="utils.Operations"%>
<%@page import="trees.kdtree.Point2D"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%

    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) ((ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData"));
    AbstractMatrix abstractMatrix = (DenseMatrix) ((DenseMatrix) session.getAttribute("abstractMatrix"));
    AbstractMatrix projectedMatrix = (DenseMatrix) ((DenseMatrix) session.getAttribute("projectedMatrix"));

    /*ArrayList<TimeInterval> listTimeIntervalsDataCategory = (ArrayList<TimeInterval>) listTimeIntervalsData.clone();
    AbstractMatrix abstractMatrixCategory = (DenseMatrix) abstractMatrix.clone();
    AbstractMatrix projectedMatrixCategory = (DenseMatrix) projectedMatrix.clone();*/
    ArrayList<TimeInterval> listTimeIntervalsDataCategory = new ArrayList<TimeInterval>();
    AbstractMatrix abstractMatrixCategory = new DenseMatrix();
    AbstractMatrix projectedMatrixCategory = new DenseMatrix();

    abstractMatrixCategory.setAttributes((ArrayList<String>) abstractMatrix.getAttributes().clone());
    projectedMatrixCategory.setAttributes((ArrayList<String>) projectedMatrixCategory.getAttributes().clone());
    abstractMatrixCategory.setLabels((ArrayList<String>) abstractMatrix.getLabels().clone());
    projectedMatrixCategory.setLabels((ArrayList<String>) projectedMatrixCategory.getLabels().clone());

    ArrayList<String> listSource1Category = (ArrayList<String>) session.getAttribute("listSource1Category");
    ArrayList<ArrayList<String>> listSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listSource1");

    ArrayList<String> filteredSource1Categories = new ArrayList<String>();
    ArrayList<Integer> filteredSource1CategoriesColors = new ArrayList<Integer>();

    Integer hierarchicalLevelRange = 0;

    // color 
    ColorScale backgroundScale = new AureaComplete();
    Color[] colorScaleBackground = backgroundScale.getColorScale();
    ArrayList<Integer> listPreviousRandomNumbersCategory = new ArrayList<Integer>();

    listPreviousRandomNumbersCategory.add(0);
    int indexColorCategory = 0;
    for (int countCategory = 0; countCategory < listSource1Category.size(); countCategory++) {
        indexColorCategory = utils.Util.randomColor(listPreviousRandomNumbersCategory, colorScaleBackground);
        listPreviousRandomNumbersCategory.add(indexColorCategory);
    }

    for (int countTimeIntervals = 0; countTimeIntervals < listTimeIntervalsData.size(); countTimeIntervals++) {
        String source1Id = listTimeIntervalsData.get(countTimeIntervals).getIdSource();

        for (int countCategories = 0; countCategories < listSource1Category.size(); countCategories++) {

            if (listSource1.get(countCategories).contains(source1Id)) {
                 AbstractVector originalVector = (AbstractVector) abstractMatrix.getRow(countTimeIntervals).clone();
                AbstractVector projectedVector = (AbstractVector) projectedMatrix.getRow(countTimeIntervals).clone();

                originalVector.setKlass(countCategories + 1);
                projectedVector.setKlass(countCategories + 1);
               
                abstractMatrixCategory.addRow(originalVector, abstractMatrix.getLabel(countTimeIntervals));
                projectedMatrixCategory.addRow(projectedVector, projectedMatrix.getLabel(countTimeIntervals));

               /*abstractMatrixCategory.getRow(countTimeIntervals).setKlass(countCategories + 1);
                projectedMatrixCategory.getRow(countTimeIntervals).setKlass(countCategories + 1);*/

                  TimeInterval timeMatrix = (TimeInterval) listTimeIntervalsData.get(countTimeIntervals).clone();
                timeMatrix.setCluster(countCategories + 1);
                timeMatrix.setIndexColorCluster(listPreviousRandomNumbersCategory.get(countCategories));
                
                listTimeIntervalsDataCategory.add(timeMatrix);
               /* listTimeIntervalsDataCategory.get(countTimeIntervals).setCluster(countCategories + 1);
                listTimeIntervalsDataCategory.get(countTimeIntervals).setIndexColorCluster(listPreviousRandomNumbersCategory.get(countCategories));
*/
                if (!filteredSource1Categories.contains(listSource1Category.get(countCategories))) {
                    filteredSource1Categories.add(listSource1Category.get(countCategories));
                    filteredSource1CategoriesColors.add(listPreviousRandomNumbersCategory.get(countCategories));
                }
                countCategories = listSource1Category.size();
            }
        }
    }
    String datasetProjectionCategory = "";
    KDTree tree = (KDTree) session.getAttribute("tree");
    KDTree treeCategory = (KDTree) tree.clone();
    Integer numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");

    /*float maxYCategory = Float.MIN_VALUE;
    float minYCategory = Float.MAX_VALUE;
    float maxXCategory = Float.MIN_VALUE;
    float minXCategory = Float.MAX_VALUE;
   
    Integer numberMaxGroup = listTimeIntervalsData.size();
    numberMaxGroup = 0;
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
        if (numberMaxGroup == 0) {
            numberMaxGroup = listTimeIntervalsData.size();
        }}
     */
    hierarchicalLevelRange = 1;

    datasetProjectionCategory = treeCategory.getD3VariableSubNodesByLevel(treeCategory.getRoot(), 1, listTimeIntervalsDataCategory, colorScaleBackground);

    session.setAttribute("treeCategory", treeCategory);
    session.setAttribute("datasetProjectionCategory", datasetProjectionCategory);
    session.setAttribute("currentNodeCategory", treeCategory.getRoot());
    session.setAttribute("currentLevelCategory", 1);
    session.setAttribute("listTimeIntervalsDataCategory", listTimeIntervalsDataCategory);


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
        <table>
            <tr>
                <td colspan="3">
                    <div style="text-align:center;">
                        <input  style="width:130px;" type="range" name="hierarchicalLevelRange" 
                                id="hierarchicalLevelRange" min="1" max="101" step="10" value="<%=hierarchicalLevelRange%>" 
                                onchange="updateHierarchicalProjectionByCategory();" >
                    </div></td>
            </tr>
            <tr>
                <td style="width: 1200px">
                    <div id="generalProjectionContentCategory" >  
                        <script type="text/javascript"> createHierarchicalProjectionMatricesByCategory("generalProjectionContentCategory",
                                    "1190", "240", "<%=datasetProjectionCategory%>", "<%=numberMaxGroup%>");</script> 
                    </div>
                </td>
                <td style="width: 50px;"></td>
                <td>

                    <table style=" border-color: black;" border="2">
                        <tr>
                            <td witdh="5px"></td> <td><b>Category</b></td>
                        </tr>
                        <% for (int i = 0; i < filteredSource1Categories.size(); i++) {
                                Color colorCell = colorScaleBackground[filteredSource1CategoriesColors.get(i)];
                                int red = colorCell.getRed();
                                int green = colorCell.getGreen();
                                int blue = colorCell.getBlue();
                        %>
                        <tr>
                            <td witdh="5px" style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);">
                                __</td><td><%=filteredSource1Categories.get(i)%></td>
                        </tr>
                        <%}%>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>