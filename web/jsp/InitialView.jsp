<%-- 
    Document   : InitialView
    Created on : Mar 9, 2017, 4:10:15 PM
    Author     : aurea
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.ArrayList"%>


<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%
    String nameXMLFile = request.getParameter("nameXMLFile");
    String nameXMLFilePrevious = (String) session.getAttribute("nameXMLFile");

    ConnectionXMLReader connectionXMLReader = new ConnectionXMLReader();

    InputStream inputStream = getServletContext().getResourceAsStream("/WEB-INF/" + nameXMLFile);

    ArrayList<String> listCategories = new ArrayList<String>();
    ArrayList<ArrayList<String>> listAttributes = new ArrayList<ArrayList<String>>();
    ArrayList<String> listSource1Category = new ArrayList<String>();
    ArrayList<ArrayList<String>> listSource1 = new ArrayList<ArrayList<String>>();
    ArrayList<ArrayList<String>> listNameSource1 = new ArrayList<ArrayList<String>>();
    ArrayList<String> listAttributesByCategory = new ArrayList<String>();
    ArrayList<String> listSource2 = new ArrayList<String>();
    ArrayList<String> listNameSource2 = new ArrayList<String>();
    String minTimeValue = "";
    String maxTimeValue = "";
    int minYear = 0;
    int minMonth = 0;
    int minDay = 0;
    int maxYear = 0;
    int maxMonth = 0;
    int maxDay = 0;
    String selectedMoment = "";
    
    if (nameXMLFile != null) {
        session.setAttribute("nameXMLFile", nameXMLFile);
        if (nameXMLFilePrevious != null && !nameXMLFilePrevious.equals(nameXMLFile)) {

            connectionXMLReader.loadConnectionXml(inputStream);
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
            session.setAttribute("connectionXMLReader", connectionXMLReader);
            session.setAttribute("flagQueryInitial", null);
            System.out.println(nameXMLFile);
        } else {
            if (nameXMLFilePrevious == null) {

                connectionXMLReader.loadConnectionXml(inputStream);
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
                session.setAttribute("connectionXMLReader", connectionXMLReader);
                session.setAttribute("flagQueryInitial", null);
                System.out.println(nameXMLFile);
            }

        }
        nameXMLFilePrevious = nameXMLFile;
    }
    String showedPath = "";
    if (nameXMLFilePrevious != null) {
        String[] nameXMLArray = nameXMLFilePrevious.split("/");
        showedPath = nameXMLArray[nameXMLArray.length - 1];
    }

    ArrayList<String> listFilePaths = new ArrayList<String>();
    ArrayList<String> listFileNames = new ArrayList<String>();

    listFilePaths.add("AirQualityConnectionXML.xml");
    listFileNames.add("Air Quality - Row=Day");

    listFilePaths.add("AirQualityConnectionXML1.xml");
    listFileNames.add("Air Quality - Row=Month");

    listFilePaths.add("SaoPauloPoliceProductivity.xml");
    listFileNames.add("Sao Paulo Police Productivity - Row=year");

    listFilePaths.add("ScintillationConnectionXML.xml");
    listFileNames.add("Ionospheric Scintillation - Row=Day");

    listFilePaths.add("ScintillationConnectionXML1.xml");
    listFileNames.add("Ionospheric Scintillation - Row=Month");

    listFilePaths.add("BigStockMarketConnectionXML.xml");
    listFileNames.add("Big Stock Market - Row=Month");

    listFilePaths.add("BigStockMarketConnectionXML1.xml");
    listFileNames.add("Big Stock Market - Row=Year");

    listFilePaths.add("StockMarketConnectionXML.xml");
    listFileNames.add("Small Stock Market - Row=Month");

    String newConfigurationFilePath = (String) session.getAttribute("newConfigurationFilePath");
    String newConfigurationFileName = (String) session.getAttribute("newConfigurationFileName");

    if (newConfigurationFilePath != null && newConfigurationFileName != null) {
        listFilePaths.add(newConfigurationFilePath);
        listFileNames.add(newConfigurationFileName);
    }
%>

<div id="InitialViewContent">
    <div class="container-fluid" style="height: 200px;   margin:0 auto; margin:auto;"></div>
    <div class="container-fluid" style="width:500px; height: 900px;   margin:0 auto; margin:auto;">
        <div class="well" style=" position:relative; ">
            <table style="text-align: center;">
                <tr>
                    <td style="width:  100px;">


                        <b>XML file:</b>
                    </td>
                    <td>
                        <select id="selectListXMLFile" name="selectListXMLFile" style="width:  300px;" style="color: black">
                            <option value="select">Select...</option>
                            <% for (int i = 0; i < listFilePaths.size(); i++) {%>
                            <option value="<%=listFilePaths.get(i)%>"  <%
                                if (nameXMLFilePrevious != null
                                        && nameXMLFilePrevious.equals(listFilePaths.get(i))) {%>
                                    selected
                                    <%}
                                    %>
                                    ><%=listFileNames.get(i)%></option>
                            <%}%>
                        </select>
                    </td>
                </tr>
                <tr style="height: 30px;">
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;"><button  id="selectFileXMLButton" name="selectFileXMLButton"  type="button"  onclick="
                            selectFileXML();"><b>Process</b></button></td>
                </tr>
                <tr style="height: 30px;">
                </tr>
                <tr> <td colspan="2" style="text-align: center;">
                        <input type="text" id="alertLoad" name="alertLoad" style="width:  400px; text-align: center;" value="<%out.println(showedPath);%>" disabled="disabled">  </td>
                </tr>
            </table>
        </div>
    </div>
</div>
