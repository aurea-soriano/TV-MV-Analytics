<%-- 
    Document   : QueryWindow
    Created on : Feb 10, 2016, 4:09:54 PM
    Author     : aurea
--%>


<%@page import="distance.PearsonCorrelation"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.Euclidean"%>
<%@page import="distance.L1Norm"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="trees.clusteringtree.ClusteringTree"%>
<%@page import="java.util.concurrent.TimeUnit"%>


<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="normalization.Standardization"%>
<%@page import="normalization.NormalizeColumnsbyAINorm"%>
<%@page import="normalization.NormalizeColumnsByNorm"%>
<%@page import="normalization.NormalizeRows"%>
<%@page import="normalization.NoneNormalization"%>
<%@page import="normalization.NormalizeColumns"%>
<%@page import="normalization.Normalization"%>
<%@page import="moments.MomentMaker"%>
<%@page import="clustering.SilhouetteCoefficient"%>
<%@page import="trees.quadtree.QuadTree"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Vector"%>
<%@page import="java.awt.Point"%>
<%@page import="java.awt.Dimension"%>
<%@page import="tsne.TSneProjection"%>
<%@page import="clustering.Xmeans"%>
<%@page import="projection.*"%>
<%@page import="dataMaker.Matrix"%>
<%@page import="color.LOCS"%>
<%@page import="color.HeatedObject"%>
<%@page import="color.BTC"%>
<%@page import="projection.FastmapProjection"%>
<%@page import="java.awt.Color"%>
<%@page import="color.AureaComplete"%>
<%@page import="utils.ColorScale"%>
<%@page import="java.util.Collections"%>
<%@page import="clustering.Kmeans"%>
<%@page import="clustering.Clustering"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.io.File"%>
<%@page import="utils.Operations"%>
<%@page import="matrix.pointsmatrix.AbstractVector"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="utils.Util"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%

    String flagQueryInitial = (String) session.getAttribute("flagQueryInitial");
    String queryUser = (String) request.getParameter("queryUser");
    String flagQueryUser = (String) session.getAttribute("flagQueryUser");
    String flagProcessed = (String) session.getAttribute("flagProcessed");

    ConnectionXMLReader connectionXMLReader = (ConnectionXMLReader) session.getAttribute("connectionXMLReader");

    System.out.println("Processing...");

    System.out.println(connectionXMLReader.getUrl());

    ArrayList<String> listCategories = new ArrayList<String>();
    ArrayList<ArrayList<String>> listAttributes = new ArrayList<ArrayList<String>>();
    ArrayList<String> listSource1Category = new ArrayList<String>();
    ArrayList<ArrayList<String>> listSource1 = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> listNameSource1 = new ArrayList<ArrayList<String>>();

    ArrayList<String> listSource2 = new ArrayList<String>();
    ArrayList<String> listNameSource2 = new ArrayList<String>();
    String minTimeValue = "";
    String maxTimeValue = "";

    String selectedAttributes = null;
    String selectedAttributesArray[] = null;
    String source2 = null;

    ArrayList<String> completeListSource1 = new ArrayList<String>();
    String fromDateStr = null;
    String toDateStr = null;
    String aggregationFunction = null;
    String clustering = null;
    Integer numberClusters = 0;
    Float averageSilhouetteCoefficient = null;
    String valueUnitTimeInterval = null;
    //   String combineAllSource1DataFlag = null;
    String selectedMoment = "";
    String selectedSimilarity = "";
    AbstractDissimilarity dissimilarity = new Euclidean();
    String valueThreshold = null;
    String messageNumberSelectedAttributes = "";
    String unitTimeInterval = null;
    int minYear = 0;
    int minMonth = 0;
    int minDay = 0;
    int maxYear = 0;
    int maxMonth = 0;
    int maxDay = 0;

    // AbstractDissimilarity abstractDissimilarity = new L1Norm();
    ArrayList<ArrayList<Integer>> resultClustering = new ArrayList<ArrayList<Integer>>();
    ArrayList<String> listAttributesByCategory = new ArrayList<String>();

    if (flagQueryInitial == null) {

        session.setAttribute("driver", connectionXMLReader.getDriver());
        session.setAttribute("url", connectionXMLReader.getUrl());
        session.setAttribute("password", connectionXMLReader.getPassword());
        session.setAttribute("username", connectionXMLReader.getUser());
        session.setAttribute("listCategorization", connectionXMLReader.getListCategorization());
        try {
            /* get all categories*/
            String attributeCategory = null;
            String queryCategoryAttributes = QueryBuilder.getListAttributeCategoriesQuery(connectionXMLReader.getAttributeTableName(),
                    connectionXMLReader.getAttributeCategoryName());
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultCategorySet = null;
            Class.forName(connectionXMLReader.getDriver()).newInstance();
            connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
            preparedStatement = connection.prepareStatement(queryCategoryAttributes);
            resultCategorySet = preparedStatement.executeQuery();
            while (resultCategorySet.next()) {
                attributeCategory = resultCategorySet.getString(connectionXMLReader.getAttributeCategoryName());
                listCategories.add(attributeCategory);
            }

            resultCategorySet.close();
            preparedStatement.close();
            connection.close();

        } catch (ClassNotFoundException e) {
            out.println("Connection Failed!");
            out.println(e);
            System.out.println(e);
            e.printStackTrace();
            return;
        } catch (SQLException ex) {
            out.println("Connection Failed!\n");
            out.println("SQLException: " + ex.getMessage() + "\n");
            out.println("SQLState: " + ex.getSQLState() + "\n");
            out.println("VendorError: " + ex.getErrorCode() + "\n");
            out.println(ex);
            System.out.println(ex);
            ex.printStackTrace();
            return;

        }

        try {
            /* get all attributes*/
            String attributeName = null;;

            for (int i = 0; i < listCategories.size(); i++) {
                String queryAttributesByCategory = QueryBuilder.getAttributesByCategory(connectionXMLReader.getAttributeTableName(),
                        connectionXMLReader.getAttributeNameName(), connectionXMLReader.getAttributeCategoryName(), listCategories.get(i));
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultAttributesByCategorySet = null;
                Class.forName(connectionXMLReader.getDriver()).newInstance();
                connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                preparedStatement = connection.prepareStatement(queryAttributesByCategory);
                resultAttributesByCategorySet = preparedStatement.executeQuery();
                ArrayList<String> tmpList = new ArrayList<String>();
                String listAttributesStr = "";
                while (resultAttributesByCategorySet.next()) {
                    attributeName = resultAttributesByCategorySet.getString(connectionXMLReader.getAttributeNameName());
                    tmpList.add(attributeName);
                    listAttributesStr += attributeName + ",";
                }
                if (listAttributesStr.endsWith(",")) {
                    listAttributesStr = listAttributesStr.substring(0, listAttributesStr.length() - 1);
                }
                listAttributesByCategory.add(listAttributesStr);
                listAttributes.add(tmpList);

                resultAttributesByCategorySet.close();
                preparedStatement.close();
                connection.close();
            }

        } catch (ClassNotFoundException e) {
            out.println(e);
            System.out.println(e);
            e.printStackTrace();
        } catch (SQLException ex) {
            out.print("SQLException: " + ex.getMessage());
            out.print("SQLState: " + ex.getSQLState());
            out.print("VendorError: " + ex.getErrorCode());
            out.println(ex);
            System.out.println(ex);
            ex.printStackTrace();
        }
        try {
            /* get all source1category*/
            String querySource1Category = QueryBuilder.getListSource1Category(connectionXMLReader.getSource1TableName(), connectionXMLReader.getSource1CategoryName());
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSource1CategorySet = null;
            Class.forName(connectionXMLReader.getDriver()).newInstance();
            connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
            preparedStatement = connection.prepareStatement(querySource1Category);
            resultSource1CategorySet = preparedStatement.executeQuery();
            while (resultSource1CategorySet.next()) {
                listSource1Category.add(resultSource1CategorySet.getString(connectionXMLReader.getSource1CategoryName()));
            }

            resultSource1CategorySet.close();
            preparedStatement.close();
            connection.close();

        } catch (ClassNotFoundException e) {
            out.println("Connection Failed!");
            out.println(e);
            System.out.println(e);
            e.printStackTrace();
            return;
        } catch (SQLException ex) {
            out.println("Connection Failed!\n");
            out.println("SQLException: " + ex.getMessage() + "\n");
            out.println("SQLState: " + ex.getSQLState() + "\n");
            out.println("VendorError: " + ex.getErrorCode() + "\n");
            out.println(ex);
            System.out.println(ex);
            ex.printStackTrace();
            return;

        }

        for (int countSource1Category = 0; countSource1Category < listSource1Category.size(); countSource1Category++) {
            try {
                /* get all source1 by category*/
                ArrayList<String> listSource1ByCategory = new ArrayList<String>();
                ArrayList<String> listNameSource1ByCategory = new ArrayList<String>();
                String querySource1ByCategory = QueryBuilder.getListSource1ByCategory(connectionXMLReader.getSource1TableName(),
                        connectionXMLReader.getSource1IdName(), connectionXMLReader.getSource1NameName(), connectionXMLReader.getSource1CategoryName(),
                        listSource1Category.get(countSource1Category));
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSource1ByCategorySet = null;
                Class.forName(connectionXMLReader.getDriver()).newInstance();
                connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                preparedStatement = connection.prepareStatement(querySource1ByCategory);
                resultSource1ByCategorySet = preparedStatement.executeQuery();
                while (resultSource1ByCategorySet.next()) {
                    listSource1ByCategory.add(resultSource1ByCategorySet.getString(connectionXMLReader.getSource1IdName()));
                    listNameSource1ByCategory.add(resultSource1ByCategorySet.getString(connectionXMLReader.getSource1NameName()));
                }

                resultSource1ByCategorySet.close();
                preparedStatement.close();
                connection.close();
                listSource1.add(listSource1ByCategory);
                listNameSource1.add(listNameSource1ByCategory);

            } catch (ClassNotFoundException e) {
                out.println("Connection Failed!");
                out.println(e);
                System.out.println(e);
                e.printStackTrace();
                return;
            } catch (SQLException ex) {
                out.println("Connection Failed!\n");
                out.println("SQLException: " + ex.getMessage() + "\n");
                out.println("SQLState: " + ex.getSQLState() + "\n");
                out.println("VendorError: " + ex.getErrorCode() + "\n");
                out.println(ex);
                System.out.println(ex);
                ex.printStackTrace();
                return;

            }
        }

        if (connectionXMLReader.getSource2TableName() != null && !connectionXMLReader.getSource2TableName().equals("")) {
            try {
                /* get all source2*/
                String source2Value = null;
                String querySource2 = QueryBuilder.getListSource2(connectionXMLReader.getSource2TableName(),
                        connectionXMLReader.getSource2IdName(), connectionXMLReader.getSource2NameName());
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSource2 = null;
                Class.forName(connectionXMLReader.getDriver()).newInstance();
                connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                preparedStatement = connection.prepareStatement(querySource2);
                resultSource2 = preparedStatement.executeQuery();
                while (resultSource2.next()) {
                    listSource2.add(resultSource2.getString(connectionXMLReader.getSource2IdName()).toString());
                    listNameSource2.add(resultSource2.getString(connectionXMLReader.getSource2NameName()).toString());
                }

                resultSource2.close();
                preparedStatement.close();
                connection.close();

            } catch (ClassNotFoundException e) {
                out.println("Connection Failed!");
                out.println(e);
                System.out.println(e);
                e.printStackTrace();
                return;
            } catch (SQLException ex) {
                out.println("Connection Failed!\n");
                out.println("SQLException: " + ex.getMessage() + "\n");
                out.println("SQLState: " + ex.getSQLState() + "\n");
                out.println("VendorError: " + ex.getErrorCode() + "\n");
                out.println(ex);
                System.out.println(ex);
                ex.printStackTrace();
                return;

            }
        }
        /*  min and max time*/
        String minTime = null;
        String maxTime = null;
        try {
            /* get min and max time*/
            String queryMinTime = QueryBuilder.getMinTime(connectionXMLReader.getInstanceTableName(), connectionXMLReader.getInstanceTimeUTCName());
            String queryMaxTime = QueryBuilder.getMaxTime(connectionXMLReader.getInstanceTableName(), connectionXMLReader.getInstanceTimeUTCName());
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            Class.forName(connectionXMLReader.getDriver()).newInstance();
            connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());

            // from min time
            preparedStatement = connection.prepareStatement(queryMinTime);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                minTime = resultSet.getString("min_time_utc");
            }

            // from max time
            preparedStatement = connection.prepareStatement(queryMaxTime);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                maxTime = resultSet.getString("max_time_utc");
            }

            resultSet.close();
            preparedStatement.close();
            connection.close();

        } catch (ClassNotFoundException e) {
            out.println(e);
            System.out.println(e);
            e.printStackTrace();
        } catch (SQLException ex) {
            out.print("SQLException: " + ex.getMessage());
            out.print("SQLState: " + ex.getSQLState());
            out.print("VendorError: " + ex.getErrorCode());
            out.println(ex);
            System.out.println(ex);
            ex.printStackTrace();
        }

        String minTimeArray[] = null;
        String maxTimeArray[] = null;
        if (minTime != null) {
            minTimeArray = minTime.split(" ");
            minTimeValue = minTimeArray[0];
            String minTimeValueArray[] = minTimeValue.split("-");
            minYear = Integer.valueOf(minTimeValueArray[0]);
            minMonth = Integer.valueOf(minTimeValueArray[1]);
            minDay = Integer.valueOf(minTimeValueArray[2]);
        }
        if (maxTime != null) {
            maxTimeArray = maxTime.split(" ");
            maxTimeValue = maxTimeArray[0];
            String maxTimeValueArray[] = maxTimeValue.split("-");
            maxYear = Integer.valueOf(maxTimeValueArray[0]);
            maxMonth = Integer.valueOf(maxTimeValueArray[1]);
            maxDay = Integer.valueOf(maxTimeValueArray[2]);
        }

        selectedMoment = request.getParameter("selectedMoment");
        if (selectedMoment == null) {
            selectedMoment = (String) session.getAttribute("selectedMoment");
            if (selectedMoment == null) {
                selectedMoment = "StatisticalMoments";
            }
        }

        selectedSimilarity = request.getParameter("selectedSimilarity");
        if (selectedSimilarity == null) {
            selectedSimilarity = (String) session.getAttribute("selectedSimilarity");
            if (selectedSimilarity == null) {
                selectedSimilarity = "Euclidean";
            }
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
        session.setAttribute("listAttributes", listAttributes);
        session.setAttribute("listSource1Category", listSource1Category);
        session.setAttribute("listSource1", listSource1);
        session.setAttribute("listSource2", listSource2);
        session.setAttribute("listNameSource1", listNameSource1);
        session.setAttribute("listNameSource2", listNameSource2);
        session.setAttribute("listCategories", listCategories);
        session.setAttribute("minTimeValue", minTimeValue);
        session.setAttribute("maxTimeValue", maxTimeValue);
        session.setAttribute("flagQueryInitial", "true");
        session.setAttribute("flagProcessed", "true");
        session.setAttribute("listAttributesByCategory", listAttributesByCategory);
        session.setAttribute("selectedMoment", selectedMoment);
        session.setAttribute("selectedSimilarity", selectedSimilarity);
        flagProcessed = "true";

    } else if (!session.isNew() && flagQueryInitial.equals("true")) {

        listAttributes = (ArrayList<ArrayList<String>>) session.getAttribute("listAttributes");
        listSource1Category = (ArrayList<String>) session.getAttribute("listSource1Category");
        listSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listSource1");
        listNameSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listNameSource1");

        listSource2 = (ArrayList<String>) session.getAttribute("listSource2");
        listNameSource2 = (ArrayList<String>) session.getAttribute("listNameSource2");
        listCategories = (ArrayList<String>) session.getAttribute("listCategories");
        listAttributesByCategory = (ArrayList<String>) session.getAttribute("listAttributesByCategory");
        minTimeValue = (String) session.getAttribute("minTimeValue");
        maxTimeValue = (String) session.getAttribute("maxTimeValue");
        String minTimeValueArray[] = minTimeValue.split("-");
        minYear = Integer.valueOf(minTimeValueArray[0]);
        minMonth = Integer.valueOf(minTimeValueArray[1]);
        minDay = Integer.valueOf(minTimeValueArray[2]);
        String maxTimeValueArray[] = maxTimeValue.split("-");
        maxYear = Integer.valueOf(maxTimeValueArray[0]);
        maxMonth = Integer.valueOf(maxTimeValueArray[1]);
        maxDay = Integer.valueOf(maxTimeValueArray[2]);

        if (queryUser != null) {
            try {
                selectedAttributes = request.getParameter("selectedAttributes");
                selectedAttributesArray = selectedAttributes.split(",");
                source2 = request.getParameter("source2");

                String source1CategoryString = request.getParameter("source1CategoryString").trim();
                String source1IndividualString = request.getParameter("source1IndividualString").trim();
                String[] source1CategoryArray = source1CategoryString.split(",");
                String[] source1IndividualArray = source1IndividualString.split(",");
                completeListSource1 = new ArrayList<String>();

                for (int countSource1Category = 0; countSource1Category < source1CategoryArray.length; countSource1Category++) {
                    if (source1CategoryArray[countSource1Category] != null && source1CategoryArray[countSource1Category] != "") {
                        try {
                            String querySource1ByCategory = QueryBuilder.getListSource1ByCategory(connectionXMLReader.getSource1TableName(),
                                    connectionXMLReader.getSource1IdName(), connectionXMLReader.getSource1NameName(), connectionXMLReader.getSource1CategoryName(),
                                    source1CategoryArray[countSource1Category]);
                            Connection connection = null;
                            PreparedStatement preparedStatement = null;
                            ResultSet resultSource1ByCategorySet = null;
                            Class.forName(connectionXMLReader.getDriver()).newInstance();
                            connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                            preparedStatement = connection.prepareStatement(querySource1ByCategory);
                            resultSource1ByCategorySet = preparedStatement.executeQuery();
                            while (resultSource1ByCategorySet.next()) {
                                completeListSource1.add(resultSource1ByCategorySet.getString(connectionXMLReader.getSource1IdName()));

                            }

                            resultSource1ByCategorySet.close();
                            preparedStatement.close();
                            connection.close();

                        } catch (ClassNotFoundException e) {
                            out.println("Connection Failed!");
                            out.println(e);
                            System.out.println(e);
                            e.printStackTrace();
                            return;
                        } catch (SQLException ex) {
                            out.println("Connection Failed!\n");
                            out.println("SQLException: " + ex.getMessage() + "\n");
                            out.println("SQLState: " + ex.getSQLState() + "\n");
                            out.println("VendorError: " + ex.getErrorCode() + "\n");
                            out.println(ex);
                            System.out.println(ex);
                            ex.printStackTrace();
                            return;

                        }
                    }
                }

                for (int countSource1Individual = 0; countSource1Individual < source1IndividualArray.length; countSource1Individual++) {
                    if (source1IndividualArray[countSource1Individual] != null && source1IndividualArray[countSource1Individual] != "") {
                        completeListSource1.add(source1IndividualArray[countSource1Individual]);
                    }
                }
                fromDateStr = request.getParameter("fromDate");
                toDateStr = request.getParameter("toDate");
                valueUnitTimeInterval = request.getParameter("valueUnitTimeInterval");
                valueThreshold = request.getParameter("valueThreshold");
                //combineAllSource1DataFlag = request.getParameter("combineAllSource1DataFlag");
                selectedMoment = request.getParameter("selectedMoment");
                if (selectedMoment == null) {
                    selectedMoment = (String) session.getAttribute("selectedMoment");
                    if (selectedMoment == null) {
                        selectedMoment = "StatisticalMoments";
                    }
                }

                selectedSimilarity = request.getParameter("selectedSimilarity");
                if (selectedSimilarity == null) {
                    selectedSimilarity = (String) session.getAttribute("selectedSimilarity");
                    if (selectedSimilarity == null) {
                        selectedSimilarity = "Euclidean";
                    }
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

                messageNumberSelectedAttributes = request.getParameter("messageNumberSelectedAttributes");
                unitTimeInterval = request.getParameter("unitTimeInterval");

                aggregationFunction = request.getParameter("aggregationFunction");
                clustering = "Xmeans";
                numberClusters = 0;

                session.setAttribute("selectedAttributes", selectedAttributes);
                session.setAttribute("source2", source2);
                session.setAttribute("completeListSource1", completeListSource1);
                session.setAttribute("fromDateStr", fromDateStr);
                session.setAttribute("toDateStr", toDateStr);
                session.setAttribute("aggregationFunction", aggregationFunction);
                session.setAttribute("clustering", clustering);
                session.setAttribute("numberClusters", numberClusters);
                session.setAttribute("valueUnitTimeInterval", valueUnitTimeInterval);
                session.setAttribute("unitTimeInterval", unitTimeInterval);
                session.setAttribute("valueThreshold", valueThreshold);
                session.setAttribute("messageNumberSelectedAttributes", messageNumberSelectedAttributes);
                session.setAttribute("selectedMoment", selectedMoment);
                session.setAttribute("selectedSimilarity", selectedSimilarity);
                // session.setAttribute("combineAllSource1DataFlag", combineAllSource1DataFlag);

                //preparing for the visualizations
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                Date initDate = null;
                Date endDate = null;

                try {

                    initDate = formatter.parse(fromDateStr);
                    endDate = formatter.parse(toDateStr);

                } catch (ParseException e) {
                    out.println(e);
                    System.out.println(e);
                    e.printStackTrace();
                }

                ArrayList<String> listRowLabels = new ArrayList<String>();
                listRowLabels = Util.getRowLabelsFromTimeUnit(initDate, endDate, connectionXMLReader.getRowUnit());

                ArrayList<String> listColumnLabels = new ArrayList<String>();
                listColumnLabels = Util.getListColumnLabels(unitTimeInterval, Integer.valueOf(valueUnitTimeInterval), connectionXMLReader.getRowUnit());
                Integer initTime = 0;
                Integer endTime = 0;

                if (unitTimeInterval.equals("minute")) {
                    initTime = 0;
                    endTime = 59;
                } else {
                    if (unitTimeInterval.equals("hour")) {
                        initTime = 0;
                        endTime = 24;
                    } else {
                        if (unitTimeInterval.equals("day")) {
                            initTime = 1;
                            endTime = 31;
                        } else {
                            if (unitTimeInterval.equals("month")) {
                                initTime = 1;
                                endTime = 12;
                            }
                        }
                    }
                }

                ArrayList<String> listSelectedAttributes = new ArrayList<String>();
                Collections.addAll(listSelectedAttributes, selectedAttributesArray);

                String arrayAttributes = "";
                for (int j = 0; j < listSelectedAttributes.size(); j++) {
                    arrayAttributes = arrayAttributes + "'" + listSelectedAttributes.get(j) + "'";
                    if (j < listSelectedAttributes.size() - 1) {
                        arrayAttributes = arrayAttributes + ",";
                    }
                }

                ArrayList<TimeInterval> listRawTimeIntervalsData = new ArrayList<TimeInterval>();

                int step = 0;
                //  if (combineAllSource1DataFlag.equals("false")) {
                //number of source1
                for (int elemSource1 = 0; elemSource1 < completeListSource1.size(); elemSource1++) {
                    String nameSource1 = "";
                    String categorySource1 = "";
                    String queryNameSource1 = QueryBuilder.getNameAndCategorySource1ByIdNameSource(connectionXMLReader.getSource1TableName(),
                            connectionXMLReader.getSource1NameName(), connectionXMLReader.getSource1CategoryName(), connectionXMLReader.getSource1IdName(),
                            String.valueOf(completeListSource1.get(elemSource1)));

                    try {
                        /* get nameOfSource1*/

                        Connection connection = null;
                        PreparedStatement preparedStatement = null;
                        ResultSet resultSet = null;
                        Class.forName(connectionXMLReader.getDriver()).newInstance();
                        connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());

                        // from 
                        preparedStatement = connection.prepareStatement(queryNameSource1);
                        resultSet = preparedStatement.executeQuery();
                        if (resultSet.next()) {
                            nameSource1 = resultSet.getString(connectionXMLReader.getSource1NameName());
                            categorySource1 = resultSet.getString(connectionXMLReader.getSource1CategoryName());
                        }

                        resultSet.close();
                        preparedStatement.close();
                        connection.close();

                        for (int j = 0; j < listSelectedAttributes.size(); j++) {
                            listRawTimeIntervalsData.add(new TimeInterval(new Matrix(listRowLabels.size(), listColumnLabels.size()), fromDateStr, toDateStr,
                                    initTime, endTime, listSelectedAttributes.get(j), 0, listColumnLabels, listRowLabels,
                                    connectionXMLReader.getSource1TableName(), nameSource1, String.valueOf(completeListSource1.get(elemSource1)),
                                    connectionXMLReader.getSource2TableName(), source2, categorySource1, listRawTimeIntervalsData.size()));

                        }

                        long secValueUnitTimeInterval = 0;
                        if (unitTimeInterval.equals("year")) {
                            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 365;
                            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(365, TimeUnit.DAYS));
                        } else if (unitTimeInterval.equals("month")) {
                            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 30;
                            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(30, TimeUnit.DAYS));
                        } else if (unitTimeInterval.equals("day")) {
                            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24;
                            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.DAYS));
                        } else if (unitTimeInterval.equals("hour")) {
                            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60;
                            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.HOURS));
                        } else if (unitTimeInterval.equals("minute")) {
                            //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60;
                            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.MINUTES));
                        }

                        String query = "";
                        if (connectionXMLReader.getInstanceThresholdAttributeName() != null && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {
                            if (aggregationFunction.equals("max")) {
                                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMaxFunctionTimeintervalThreshold(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                            } else if (aggregationFunction.equals("avg")) {
                                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataAvgFunctionTimeintervalThreshold(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                            } else if (aggregationFunction.equals("min")) {
                                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                            } else if (aggregationFunction.equals("std")) {
                                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                            } else if (aggregationFunction.equals("median")) {
                                query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMedianFunctionTimeintervalThreshold(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                            }

                        } else {
                            if (aggregationFunction.equals("max")) {

                                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMaxFunctionTimeinterval(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval);
                            } else if (aggregationFunction.equals("avg")) {
                                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataAvgFunctionTimeinterval(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval);
                            } else if (aggregationFunction.equals("min")) {
                                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMinFunctionTimeinterval(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval);
                            } else if (aggregationFunction.equals("std")) {
                                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataStdFunctionTimeinterval(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval);
                            } else if (aggregationFunction.equals("median")) {
                                query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMedianFunctionTimeinterval(),
                                        arrayAttributes, source2, completeListSource1.get(elemSource1), fromDateStr, toDateStr, secValueUnitTimeInterval);
                            }
                        }

                        System.out.println(query);
                        connection = null;
                        preparedStatement = null;
                        ResultSet resultCategorySet = null;
                        Class.forName(connectionXMLReader.getDriver()).newInstance();
                        connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                        preparedStatement = connection.prepareStatement(query);
                        resultCategorySet = preparedStatement.executeQuery();

                        if (!resultCategorySet.isBeforeFirst()) {
                        } else {
                            while (resultCategorySet.next()) {

                                try {

                                    String timeInstance = resultCategorySet.getString(connectionXMLReader.getInstanceTimeUTCName());

                                    Integer positionY = Util.getRowLabelIndex(listRowLabels, timeInstance, connectionXMLReader.getRowUnit());
                                    Integer positionX = Util.getColumnLabelIndex(listColumnLabels, timeInstance, unitTimeInterval, connectionXMLReader.getRowUnit());

                                    String round = resultCategorySet.getString("round");
                                    String[] values = round.replace("{", "").replace("}", "").split(",");
                                    int count = 0;
                                    for (int j = step; j < step + values.length; j++) {
                                        if (values[count] != "NaN") {
                                            double value = Double.valueOf(values[count]);
                                            listRawTimeIntervalsData.get(j).getMatrix().setValue(positionY, positionX, value);
                                        }

                                        count++;
                                    }
                                } catch (Exception e) {
                                    out.println(e);
                                    System.out.println(e);
                                    e.printStackTrace();
                                }
                            }
                            resultCategorySet.close();
                            preparedStatement.close();
                            connection.close();
                        }
                        step += listSelectedAttributes.size();

                    } catch (ClassNotFoundException e) {
                        out.println(e);
                        System.out.println(e);
                        e.printStackTrace();
                        System.out.println("ERROR:" + queryNameSource1);
                    } catch (SQLException ex) {
                        out.println(ex);
                        System.out.println(ex);
                        ex.printStackTrace();
                        out.print("SQLException: " + ex.getMessage());
                        out.print("SQLState: " + ex.getSQLState());
                        out.print("VendorError: " + ex.getErrorCode());
                        System.out.println("ERROR:" + queryNameSource1);
                    }
                }
                //   }

                /*   else {
                    for (int j = 0; j < listSelectedAttributes.size(); j++) {
                        listRawTimeIntervalsData.add(new TimeInterval(new Matrix(listRowLabels.size(), listColumnLabels.size()),
                                fromDateStr, toDateStr, initTime, endTime, listSelectedAttributes.get(j), 0, listColumnLabels, listRowLabels,
                                connectionXMLReader.getSource1TableName(), String.valueOf("All"), String.valueOf("All"), connectionXMLReader.getSource2TableName(), source2, String.valueOf("All")));

                    }

                    long secValueUnitTimeInterval = 0;
                    if (unitTimeInterval.equals("year")) {
                        //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 365;
                        secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(365, TimeUnit.DAYS));
                    } else if (unitTimeInterval.equals("month")) {
                        //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 30;
                        secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(30, TimeUnit.DAYS));
                    } else if (unitTimeInterval.equals("day")) {
                        //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24;
                        secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.DAYS));
                    } else if (unitTimeInterval.equals("hour")) {
                        //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60;
                        secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.HOURS));
                    } else if (unitTimeInterval.equals("minute")) {
                        //secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60;
                        secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * (TimeUnit.SECONDS.convert(1, TimeUnit.MINUTES));
                    }

                    String query = "";
                    if (connectionXMLReader.getInstanceThresholdAttributeName() != null && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {
                        if (aggregationFunction.equals("max")) {
                            query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataMaxFunctionTimeintervalThresholdForAllSource1(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                        } else if (aggregationFunction.equals("avg")) {
                            query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataAvgFunctionTimeintervalThresholdForAllSource1(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                        } else if (aggregationFunction.equals("min")) {
                            query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                        } else if (aggregationFunction.equals("std")) {
                            query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                        } else if (aggregationFunction.equals("median")) {
                            query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataMedianFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                        }

                    } else {
                        if (aggregationFunction.equals("max")) {
                            query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataMaxFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                                    secValueUnitTimeInterval);
                        } else if (aggregationFunction.equals("avg")) {
                            query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataAvgFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                                    secValueUnitTimeInterval);
                        } else if (aggregationFunction.equals("min")) {
                            query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                                    secValueUnitTimeInterval);
                        } else if (aggregationFunction.equals("std")) {
                            query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                                    secValueUnitTimeInterval);
                        } else if (aggregationFunction.equals("median")) {
                            query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataMedianFunctionTimeintervalThreshold(),
                                    arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                                    secValueUnitTimeInterval);
                        }
                    }

                    System.out.println(query);

                    Connection connection = null;
                    PreparedStatement preparedStatement = null;
                    ResultSet resultCategorySet = null;
                    Class.forName(connectionXMLReader.getDriver()).newInstance();
                    connection = DriverManager.getConnection(connectionXMLReader.getUrl(), connectionXMLReader.getUser(), connectionXMLReader.getPassword());
                    preparedStatement = connection.prepareStatement(query);
                    resultCategorySet = preparedStatement.executeQuery();

                    if (!resultCategorySet.isBeforeFirst()) {
                    } else {
                        while (resultCategorySet.next()) {
                            try {
                                String timeInstance = resultCategorySet.getString(connectionXMLReader.getInstanceTimeUTCName());

                                Integer positionY = Util.getRowLabelIndex(listRowLabels, timeInstance, connectionXMLReader.getRowUnit());
                                Integer positionX = Util.getColumnLabelIndex(listColumnLabels, timeInstance, unitTimeInterval, connectionXMLReader.getRowUnit());
                                String round = resultCategorySet.getString("round");
                                String[] values = round.replace("{", "").replace("}", "").split(",");
                                int count = 0;
                                for (int j = step; j < step + values.length; j++) {
                                    if (values[count] != "NaN") {
                                        double value = Double.valueOf(values[count]);
                                        listRawTimeIntervalsData.get(j).getMatrix().setValue(positionY, positionX, value);
                                    }

                                    count++;
                                }
                            } catch (Exception e) {

                            }
                        }
                        resultCategorySet.close();
                        preparedStatement.close();
                        connection.close();
                    }
                    step += listSelectedAttributes.size();

                }*/
                AbstractMatrix originalAbstractMatrix = new DenseMatrix();
                for (int k = 0; k < listRawTimeIntervalsData.size(); k++) {
                    AbstractVector moments = null;
                    if (!listRawTimeIntervalsData.get(k).isEmpty()) {

                        if (selectedMoment.equals("HuMoments")) {
                            moments = MomentMaker.huMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                        } else {
                            if (selectedMoment.equals("StatisticalMoments")) {
                                moments = MomentMaker.statisticalMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix(), listRawTimeIntervalsData.get(k).getOriginalMissingDataImpact());
                            } else {
                                if (selectedMoment.equals("HuStatisticalMoments")) {
                                    moments = MomentMaker.huStatisticalMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix(), listRawTimeIntervalsData.get(k).getOriginalMissingDataImpact());
                                } else {
                                    if (selectedMoment.equals("NormalizedCentralMoments")) {
                                        moments = MomentMaker.normalizedcentralMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                                    } else {
                                        if (selectedMoment.equals("ZaidNormalizedCentralMoments")) {
                                            moments = MomentMaker.zaidNormalizedcentralMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                                        } else {
                                            if (selectedMoment.equals("FlusserSukMoments")) {
                                                moments = MomentMaker.flusserSukMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                                            } else {
                                                if (selectedMoment.equals("OrthogonalVariantMoments")) {
                                                    moments = MomentMaker.orthogonalVariantMoments(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                                                } else {
                                                    if (selectedMoment.equals("OrthogonalVariantAndStatisticalMoments")) {
                                                        moments = MomentMaker.orthogonalVariantAndStatisticalMoments(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                                                    } else {
                                                        moments = MomentMaker.statisticalMomentsVector(listRawTimeIntervalsData.get(k).getProcessedMatrix(), listRawTimeIntervalsData.get(k).getOriginalMissingDataImpact());
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        //  AbstractVector moments = MomentMaker.orthogonalVariantMoments(listRawTimeIntervalsData.get(k).getProcessedMatrix());
                        moments.setId(k + 1);
                        originalAbstractMatrix.addRow(moments);
                    } else {
                        if (selectedMoment.equals("HuMoments")) {
                            moments = MomentMaker.emptyMomentVector(7);
                        } else {
                            if (selectedMoment.equals("StatisticalMoments")) {
                                moments = MomentMaker.emptyMomentVector(6);
                            } else {
                                if (selectedMoment.equals("HuStatisticalMoments")) {
                                    moments = MomentMaker.emptyMomentVector(13);
                                } else {
                                    if (selectedMoment.equals("NormalizedCentralMoments")) {
                                        moments = MomentMaker.emptyMomentVector(16);
                                    } else {
                                        if (selectedMoment.equals("ZaidNormalizedCentralMoments")) {
                                            moments = MomentMaker.emptyMomentVector(16);
                                        } else {
                                            if (selectedMoment.equals("FlusserSukMoments")) {
                                                moments = MomentMaker.emptyMomentVector(6);
                                            } else {
                                                if (selectedMoment.equals("OrthogonalVariantMoments")) {
                                                    moments = MomentMaker.emptyMomentVector(5);
                                                } else {
                                                    if (selectedMoment.equals("OrthogonalVariantAndStatisticalMoments")) {
                                                        moments = MomentMaker.emptyMomentVector(10);
                                                    } else {
                                                        moments = MomentMaker.emptyMomentVector(6);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // AbstractVector moments = MomentMaker.emptyMomentVector(5);
                        originalAbstractMatrix.addRow(moments);
                    }

                }
                originalAbstractMatrix.setAttributes(listSelectedAttributes);
                Normalization normalization = new NormalizeColumns();
                AbstractMatrix abstractMatrix = new DenseMatrix();
                abstractMatrix = normalization.execute(originalAbstractMatrix);

                for (int k = 0; k < abstractMatrix.getRowCount(); k++) {

                    listRawTimeIntervalsData.get(k).setMoments(abstractMatrix.getRow(k));
                    // System.out.println(Arrays.toString(abstractMatrix.getRow(k).toArray()));
                }

                if (listRawTimeIntervalsData.size() < numberClusters) {
                    numberClusters = listRawTimeIntervalsData.size();
                }

                //clustering with kmeans
                Clustering clusteringMethod = null;
                resultClustering = new ArrayList<ArrayList<Integer>>();
                int[] listMedoids = null;

                clusteringMethod = new Xmeans(listSelectedAttributes.size());
                resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                listMedoids = clusteringMethod.getMedoids(abstractMatrix);

                //hierarchicalClustering
                ClusteringTree clusteringTree = new ClusteringTree();
                clusteringTree.buildClusteringTree(0, abstractMatrix, "Xmeans", 0, clusteringMethod, resultClustering);

                //adjustment of colors
                ColorScale backgroundScale = new AureaComplete();
                Color[] colorScaleBackground = backgroundScale.getColorScale();
                ColorScale cellScale = new HeatedObject();
                Color[] colorScaleCell = cellScale.getColorScale();

                ArrayList<Integer> listPreviousRandomNumbers = new ArrayList<Integer>();
                listPreviousRandomNumbers.add(0);
                int indexColorCluster = 0;

                for (int countCluster = 0; countCluster < resultClustering.size(); countCluster++) {
                    indexColorCluster = listPreviousRandomNumbers.get(listPreviousRandomNumbers.size() - 1);
                    for (int itemCluster = 0; itemCluster < resultClustering.get(countCluster).size(); itemCluster++) {

                        int indexTmpInterval = resultClustering.get(countCluster).get(itemCluster);
                        listRawTimeIntervalsData.get(indexTmpInterval).setCluster(countCluster + 1);
                        listRawTimeIntervalsData.get(indexTmpInterval).setIndexColorCluster(indexColorCluster);
                        //fill clusters in matrix
                        abstractMatrix.getRow(indexTmpInterval).setKlass(countCluster + 1);
                    }
                    indexColorCluster = utils.Util.randomColor(listPreviousRandomNumbers, colorScaleBackground);
                    listPreviousRandomNumbers.add(indexColorCluster);
                }

                //measuring the clustering
                if (resultClustering.size() > 1) {
                    SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
                    float[] silhouetteCoefficients = silhouetteCoefficient.execute(abstractMatrix, dissimilarity);
                    averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
                    averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;
                } else {
                    averageSilhouetteCoefficient = 0.f;
                }

                //adding first important variables = medois
                ArrayList<Integer> listSelectedAttributesSubset = new ArrayList<Integer>();
                if (listMedoids != null) {
                    for (int cntMedoids = 0; cntMedoids < listMedoids.length; cntMedoids++) {
                        listSelectedAttributesSubset.add(listMedoids[cntMedoids]);
                    }
                }

                //projection
                LSPProjection2D lsp = new LSPProjection2D();
                lsp.setControlPointsChoice(ControlPointsType.KMEANS);
                //lsp.setNumberNeighbors(3);
                lsp.setNumberControlPoints(abstractMatrix.getRowCount() / 10);

                session.setAttribute("listTimeIntervalsData", listRawTimeIntervalsData);
                session.setAttribute("clusteringTree", clusteringTree);
                session.setAttribute("currentClusteringNode", null);
                session.setAttribute("currentListTimeMatricesId", null);
                session.setAttribute("resultClustering", resultClustering);
                session.setAttribute("listMedoids", listMedoids);
                session.setAttribute("flagQueryUser", "true");
                session.setAttribute("colorScaleBackground", colorScaleBackground);
                session.setAttribute("colorScaleCell", colorScaleCell);
                session.setAttribute("listSelectedAttributesSubset", listSelectedAttributesSubset);
                session.setAttribute("abstractMatrix", abstractMatrix);
                session.setAttribute("clusteringMethod", clusteringMethod);
                session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient);
                session.setAttribute("flagProcessed", "true");
                flagProcessed = "true";
            } catch (Exception e) {
                out.println(e);
                System.out.println(e);
                e.printStackTrace();
                System.out.println("Query without results.");
                session.setAttribute("projectedMatrix", null);
                session.setAttribute("listTimeIntervalsData", null);
                session.setAttribute("clusteringTree", null);
                session.setAttribute("currentClusteringNode", null);
                session.setAttribute("currentListTimeMatricesId", null);
                session.setAttribute("resultClustering", null);
                session.setAttribute("listMedoids", null);
                session.setAttribute("flagQueryUser", null);
                session.setAttribute("colorScaleBackground", null);
                session.setAttribute("colorScaleCell", null);
                session.setAttribute("listSelectedAttributesSubset", null);
                session.setAttribute("abstractMatrix", null);
                session.setAttribute("clusteringMethod", null);
                session.setAttribute("flagProcessed", null);

                flagProcessed = null;

            }

        } else if (!session.isNew() && flagQueryUser != null) {

            selectedAttributes = (String) session.getAttribute("selectedAttributes");
            selectedAttributesArray = selectedAttributes.split(",");
            source2 = (String) session.getAttribute("source2");

            completeListSource1 = (ArrayList<String>) session.getAttribute("completeListSource1");
            fromDateStr = (String) session.getAttribute("fromDateStr");
            toDateStr = (String) session.getAttribute("toDateStr");

            unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
            valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
            valueThreshold = (String) session.getAttribute("valueThreshold");
            messageNumberSelectedAttributes = (String) session.getAttribute("messageNumberSelectedAttributes");
            //combineAllSource1DataFlag = (String) session.getAttribute("combineAllSource1DataFlag");
            resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
            listAttributesByCategory = (ArrayList<String>) session.getAttribute("listAttributesByCategory");
            aggregationFunction = (String) session.getAttribute("aggregationFunction");
            clustering = (String) session.getAttribute("clustering");
            numberClusters = (Integer) session.getAttribute("numberClusters");
            session.setAttribute("flagProcessed", "true");
            flagProcessed = "true";
            averageSilhouetteCoefficient = (Float) session.getAttribute("averageSilhouetteCoefficient");

            selectedMoment = (String) session.getAttribute("selectedMoment");
            if (selectedMoment == null) {
                selectedMoment = "StatisticalMoments";
            }

            selectedSimilarity = (String) session.getAttribute("selectedSimilarity");
            if (selectedSimilarity == null) {
                selectedSimilarity = "Euclidean";
            }

        }
    }

%>



<div class="container-fluid" style="width:770px; height: 900px;   margin:0 auto; margin:auto;">

    <table style="width:750px; ">
        <tr>
            <td style="width:300px; ">

                <div class="well" style=" position:relative; ">
                    <table>

                        <tr>
                            <td>
                                <b>Attributes:</b>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <label>
                                    <input type="checkbox" name="selectedAllAttributesCheckbox"  id="labelAllAttributesCheckbox"   value="SelectAllAttributes" onclick="checkAllAttributes(this);" >
                                    <span>Select All Attributes</span>
                                </label>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="width:240px;height:785px;overflow:auto;">

                                    <%  for (int i = 0; i < listCategories.size(); i++) {%>
                                    <div class="checkbox">
                                        <label>----------------------</label><br>
                                        <label>
                                            <input type="checkbox" name="selectedCategoriesCheckbox" id="<%=listCategories.get(i)%>CategoriesCheckbox" 
                                                   onclick="checkAttributesByCategory('<%=listAttributesByCategory.get(i)%>', '<%=listCategories.get(i)%>CategoriesCheckbox');
                                                           countSelectedAttributes();
                                                           clearMessage();"value="<%=listCategories.get(i)%>"

                                                   >
                                            <b style="color: #398439;"><%out.print(listCategories.get(i) + ": ");%></b>
                                        </label>
                                    </div>
                                    <%
                                        for (int j = 0; j < listAttributes.get(i).size(); j++) {
                                            String nameAttribute = listAttributes.get(i).get(j);
                                    %>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="selectedAttributesCheckbox" onclick="countSelectedAttributes();
                                                    clearMessage();"value="<%=nameAttribute%>"
                                                   <%if (selectedAttributesArray != null && Arrays.asList(selectedAttributesArray).contains(nameAttribute)) {%>
                                                   checked  
                                                   <%}%>

                                                   >
                                            <span><%out.print(listAttributes.get(i).get(j));%></span>
                                        </label>
                                    </div>
                                    <%}
                                        }
                                    %>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label> <input style="width:230px;" id="numberSelectedAttributesText" type="text" disabled
                                               <% if (messageNumberSelectedAttributes != null) {
                                               %>
                                               value="<%=messageNumberSelectedAttributes%>"
                                               <%}
                                               %>
                                               ></label>
                            </td>
                        </tr>
                    </table>
                </div></td>
            <td style="width:450px;">
                <div class="well" style="height: 900px;  position:relative; " >
                    <table style="line-height: 250%">
                        <tr>
                            <td colspan="4">
                                <b>Date Range:</b>
                            </td>
                        </tr>

                        <tr>
                            <td><b>From:</b> </td>
                            <td>
                                <script>
                                    $(function () {
                                        $("#fromDate").datepicker({
                                            defaultDate: "today",
                                            changeMonth: true,
                                            changeYear: true,
                                            dateFormat: 'yy-mm-dd',
                                            numberOfMonths: 2,
                                            minDate: new Date(<%=minYear%>, <%=minMonth - 1%>, <%=minDay%>),
                                            maxDate: new Date(<%=maxYear%>, <%=maxMonth - 1%>, <%=maxDay%>)
                                                    // onClose: function (selectedDate) {
                                                    //     $("#toDate").datepicker("option", "minDate", selectedDate);
                                                    //}
                                        });
                                        $("#toDate").datepicker({
                                            defaultDate: "today",
                                            changeMonth: true,
                                            changeYear: true,
                                            dateFormat: 'yy-mm-dd',
                                            numberOfMonths: 2,
                                            minDate: new Date(<%=minYear%>, <%=minMonth - 1%>, <%=minDay%>),
                                            maxDate: new Date(<%=maxYear%>, <%=maxMonth - 1%>, <%=maxDay%>)
                                                    //onClose: function (selectedDate) {
                                                    //    $("#fromDate").datepicker("option", "maxDate", selectedDate);
                                                    // }
                                        });
                                    });
                                </script> <!--min='<%//out.print(minTimeValue);%>'  max='<%//out.print(maxTimeValue);%>'-->
                                <input type="text" id='fromDate' name='fromDate' onchange='clearMessage();'  
                                       <%
                                           if (fromDateStr != null) {%>
                                       value="<%out.print(fromDateStr);%>"  
                                       <% }

                                       %>
                                       ></td>
                            <td><b>To:</b> </td>
                            <td>      <!--min='<%//out.print(minTimeValue);%>'  max='<%//out.print(maxTimeValue);%>'-->
                                <input type="text" id='toDate' name='toDate' onchange='clearMessage();' 
                                       <%
                                           if (toDateStr != null) {%>
                                       value="<%out.print(toDateStr);%>"  
                                       <% }%>></td>
                        </tr>
                        <!--tr>
                            <td colspan="4"><b><%//out.print(connectionXMLReader.getTimeRangesLabel() + ":");%></b></td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <select name="listIntervalsSelect" id="listIntervalsSelect" multiple size="3" style="width: 170px;" onchange="clearMessage();">

                        <%                                                // if (intervalTimesArray != null) {
                            // for (int i = 0; i < intervalTimesArray.length; i++) {

                        %>
                        <option value="<%//=intervalTimesArray[i]%>"><%//=intervalTimesArray[i]%></option>
                        <%//}
                            //} %>


                    </select>
                </td>
            </tr>
            <tr >
                <td colspan="4" >
                    <br>

                    <table style="text-align: center;">
                        <tr>
                            <td><div id="slider-range" style='width:290px'></div></td>
                            <td>&nbsp; &nbsp; </td>
                            <td><input type="submit" name="scheduleSubmit" value="+" id="scheduleSubmit" ></td>
                            <td><input type="submit" name="removeSubmit" value="-" id="removeSubmit" ></td>
                        </tr></table>
                </td>
            </tr>
            <tr >
                <td colspan="4" style="text-align: center;">
                    <span id="time"> </span>
                </td>
            </tr>
            <tr >

                <td colspan="4" style="text-align: center;">

                    <span id="SlideMax"></span>

                        <%
                            /* ArrayList<String> listTimeRangesOptions = connectionXMLReader.getListTimeRangesOptions();
                            String minTimeRange = listTimeRangesOptions.get(0);
                            String maxTimeRange = listTimeRangesOptions.get(listTimeRangesOptions.size() - 1);
                            String valuesTimeRange = "";
                            for (int aux = 0; aux < listTimeRangesOptions.size() - 1; aux++) {
                                valuesTimeRange += listTimeRangesOptions.get(aux) + ", ";
                            }
                            valuesTimeRange += listTimeRangesOptions.get(listTimeRangesOptions.size() - 1);*/
                        %>
                        <script type="text/javascript">
                            var startTime;
                            var endTime;
                            $("#slider-range").slider({
                                range: true, min: <%//=minTimeRange
                        %>, max: <%//=maxTimeRange
                        %>, values: [<%//=valuesTimeRange
                        %>], 
                        slide: slideTime
                    });
                    function slideTime(event, ui) {
                        var val0 = $("#slider-range").slider("values", 0);
                        var val1 = $("#slider-range").slider("values", 1);
                        startTime = val0;//getTime(hours0);
                        endTime = val1;// getTime(hours1);
                        $("#time").text(startTime + ' - ' + endTime);
                    }

                    $("#scheduleSubmit").on('click', function () {
                        // Make sure it's not a duplicate; if so, don't add
                        var match = false;
                        var valueInterval = startTime + ' - ' + endTime + '';
                        $('#listIntervalsSelect option').each(function () {
                            if (valueInterval === this.value)
                                match = true;
                        });
                        if (match)
                        {
                            alert("This time interval exists.");
                            return false;
                        }

                        // Add the number to the <select>
                        $('#listIntervalsSelect').append(
                                $('<option></option>').html(valueInterval).val(valueInterval)
                                );

                    });
                    $("#removeSubmit").on('click', function () {
                        $('#listIntervalsSelect :selected').remove();

                    });
                    slideTime();
                </script>
            </td>
        </tr-->
                        <tr>
                            <td colspan="4"><br>
                                <br></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right; ">

                                <b>Time Unit:</b></td>
                            <td colspan="2">      <input name="valueUnitTimeInterval" id="valueUnitTimeInterval" size="4"  maxlength="4"  <%                                if (valueUnitTimeInterval != null) {%>
                                                         value="<%=valueUnitTimeInterval%>"
                                                         <%}
                                                         %> onchange="clearMessage();" style="width: 40px"

                                                         onkeypress='return event.charCode >= 48 && event.charCode <= 57'> 
                                <select name="selectUnitTimeInterval" id="selectUnitTimeInterval"    style="width: 90px" onchange="clearMessage();">
                                    <%ArrayList<String> listTimeUnitOptions = connectionXMLReader.getListTimeUnitOptions();
                                        for (int aux = 0; aux < listTimeUnitOptions.size(); aux++) {%>
                                    <option value="<%out.print(listTimeUnitOptions.get(aux));%>"  <%
                                        if (unitTimeInterval != null && unitTimeInterval.equals(listTimeUnitOptions.get(aux))) {%>
                                            selected
                                            <%}
                                            %>><%out.print(listTimeUnitOptions.get(aux) + "(s)");%></option>

                                    <%}%>
                                </select></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right; "><b>Aggregation Function:</b></td>
                            <td colspan="2">   <select name="selectAggregationFunction" id="selectAggregationFunction"    style="width: 200px" onchange="clearMessage();">

                                    <%ArrayList<String> listAggregationFunctionOptions = connectionXMLReader.getListAggregationFunctionOptions();
                                        for (int aux = 0; aux < listAggregationFunctionOptions.size(); aux++) {%>
                                    <option value="<%out.print(listAggregationFunctionOptions.get(aux));%>"  <%
                                        if (aggregationFunction != null && aggregationFunction.equals(listAggregationFunctionOptions.get(aux))) {%>
                                            selected
                                            <%}
                                            %>><%out.print(listAggregationFunctionOptions.get(aux));%></option>

                                    <%}%>
                                </select></td>
                        </tr>
                        <% if (connectionXMLReader.getInstanceThresholdAttributeName() != null
                                    && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {%>
                        <tr>
                            <td colspan="2" style="text-align: right; "><b><%out.print("Minimum " + connectionXMLReader.getInstanceThresholdAttributeName());%></b></td>
                            <td colspan="2">  
                                <select name="valueThreshold" id="valueThreshold"  style="width: 200px;" onchange="clearMessage();">
                                    <%
                                        ArrayList<String> listThresholdValues = connectionXMLReader.getListThresholdValues();
                                        for (int aux = 0; aux < listThresholdValues.size(); aux++) {
                                    %>
                                    <option value="<%=listThresholdValues.get(aux)%>"
                                            <%if (valueThreshold != null && valueThreshold.equals(listThresholdValues.get(aux))) {%>
                                            selected<%}%>><%out.print(listThresholdValues.get(aux));%></option>
                                    <%
                                        } %>
                                </select>
                            </td>
                        </tr>
                        <%} %>
                        <%if (connectionXMLReader.getSource2TableName() != null && !connectionXMLReader.getSource2TableName().equals("")) {%>
                        <tr> <td colspan="2" style="text-align: right; "><b><%out.print(connectionXMLReader.getSource2TableName() + ":");%></b></td>
                            <td colspan="2">  <select name="selectListSource2" id="selectListSource2"    style="width: 200px" onchange="clearMessage();">
                                    <% for (int aux = 0; aux < listSource2.size(); aux++) {
                                    %>
                                    <option value="<%out.print(listSource2.get(aux));%>"  <%
                                        if (source2 != null && source2.equals(listSource2.get(aux))) {%>
                                            selected
                                            <%}
                                            %>

                                            ><%out.print(listNameSource2.get(aux));%></option>
                                    <%}
                                    %>
                                </select></td>
                        </tr>
                        <%}%>
                        <!--tr> <td colspan="2" style="text-align: right; "><b>Combine all //out.print(connectionXMLReader.getSource1TableName()); data?:</b></td>
                            <td colspan="2">  
                                <input type="checkbox" name="combineAllSource1DataCheckbox"  id="combineAllSource1DataCheckbox"   
                                       onclick="combineAllSource1Data(this);"

                        //if (combineAllSource1DataFlag != null && combineAllSource1DataFlag.equals("true")) {
                        checked
                        //}
             </td>
         </tr-->
                        <tr>
                            <td colspan="2" style="text-align: right; "><b><%out.print(connectionXMLReader.getSource1TableName() + ":");%></b></td>
                            <td colspan="2"> <select multiple="multiple" id="selectListSource1" name="selectListSource1"  style="color: white">
                                    <% for (int countSource1Category = 0; countSource1Category < listSource1Category.size(); countSource1Category++) {
                                    %>
                                    <optgroup class="group selected" label="<%out.print(listSource1Category.get(countSource1Category));%>"
                                              >
                                        <% for (int countSource1 = 0; countSource1 < listSource1.get(countSource1Category).size(); countSource1++) {
                                                String source1SelectId = listSource1.get(countSource1Category).get(countSource1);
                                                String source1SelectName = listNameSource1.get(countSource1Category).get(countSource1);

                                        %>
                                        <option value="<%out.print(source1SelectId);%>"
                                                <%if (completeListSource1.contains(source1SelectId)) {%>
                                                selected
                                                <%}%>
                                                ><%out.print(source1SelectName);%></option>
                                        <%}
                                        %>
                                    </optgroup>
                                    <%}
                                    %>
                                </select>
                                <script>
                                    $("#selectListSource1").multipleSelect({
                                        width: 200,
                                        multiple: true,
                                        multipleWidth: 500

                                    });
                                </script></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right; "><b>Moments:</b></td>
                            <td colspan="2"> 
                                <select id="selectListMoments" name="selectListMoments" style="width: 200px;">
                                    <option value="HuMoments"
                                            <%if (selectedMoment.contains(
                                                        "HuMoments")) {%>
                                            selected
                                            <%}%>
                                            >Hu Moments - Invariant</option>
                                    <option value="StatisticalMoments"
                                            <%if (selectedMoment.contains(
                                                        "StatisticalMoments")) {%>
                                            selected
                                            <%}%>
                                            >Statistical Moments - Invariant</option>
                                    <option value="HuStatisticalMoments"
                                            <%if (selectedMoment.contains(
                                                        "HuStatisticalMoments")) {%>
                                            selected
                                            <%}%>
                                            >Hu + Statistical Moments - Invariant</option>
                                    <option value="NormalizedCentralMoments"
                                            <%if (selectedMoment.contains(
                                                        "NormalizedCentralMoments")) {%>
                                            selected
                                            <%}%>
                                            >Normalized Central Moments - Invariant</option>
                                    <option value="ZaidNormalizedCentralMoments"
                                            <%if (selectedMoment.contains(
                                                        "ZaidNormalizedCentralMoments")) {%>
                                            selected
                                            <%}%>
                                            >Zaid Normalized Central Moments - Invariant</option>
                                    <option value="FlusserSukMoments"
                                            <%if (selectedMoment.contains(
                                                        "FlusserSukMoments")) {%>
                                            selected
                                            <%}%>
                                            >Flusser Suk Moments - Invariant</option>
                                    <option value="OrthogonalVariantMoments"
                                            <%if (selectedMoment.contains(
                                                        "OrthogonalVariantMoments")) {%>
                                            selected
                                            <%}%>
                                            >Orthogonal Variant Moments</option>
                                    <option value="OrthogonalVariantAndStatisticalMoments"
                                            <%if (selectedMoment.contains(
                                                        "OrthogonalVariantAndStatisticalMoments")) {%>
                                            selected
                                            <%}%>
                                            >Orthogonal Variant and Statistical Moments</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" style="text-align: right; "><b>(Dis)Similarity:</b></td>
                            <td colspan="2"> 
                                <select id="selectListSimilarity" name="selectListSimilarity" style="width: 200px;">
                                    <option value="Euclidean"
                                            <%if (selectedSimilarity.contains("Euclidean")) {%>
                                            selected
                                            <%}%>
                                            >Euclidean</option>
                                    <option value="Manhattan"
                                            <%if (selectedSimilarity.contains("Manhattan")) {%>
                                            selected
                                            <%}%>
                                            >Manhattan</option>
                                    <option value="Pearson"
                                            <%if (selectedSimilarity.contains(
                                                        "Pearson")) {%>
                                            selected
                                            <%}%>
                                            >Pearson-Correlation</option>                                   
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td colspan='4' style='text-align:center;'>
                                <br>
                                <br>
                                <button  id="createVisualizationTimeSeriesButton" name="createVisualizationTimeSeriesButton"  type="button"  onclick="
                                        createVisualization('<%out.print(connectionXMLReader.getInstanceThresholdAttributeName());%>',
                                                '<%out.print(connectionXMLReader.getSource1TableName());%>',
                                                '<%out.print(connectionXMLReader.getSource2TableName());%>'
                                                );"><b>Visualize</b></button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan='4' style='text-align:center;'>
                                <br>
                                <br>
                                <%if (selectedAttributesArray != null && flagProcessed
                                            != null) {%> 
                                <textarea rows="2" cols="50" name="successMessage"  id="successMessage" disabled style="text-align: center; color: black;" >Query was successfully processed.
                                </textarea>
                                <%} else if (selectedAttributesArray != null && flagProcessed
                                        == null) {%> <textarea rows="2" cols="50" name="successMessage"  id="successMessage" disabled style="text-align: center; color: red;" >Query without results.
                                </textarea><%} else {%> <textarea rows="2" cols="50" name="successMessage"  id="successMessage" disabled style="text-align: center; color: black;" >
                                </textarea><%}%>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <br>

                </div></td>
        </tr>
    </table>
</div>